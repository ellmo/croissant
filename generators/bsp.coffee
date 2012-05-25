class @Croissant.Generators.BSPLeaf

  constructor: (x, y) ->
    @x = x
    @y = y

class @Croissant.Generators.BSPTree

  constructor: (parent, x, y, min_room_size, leaf_container = null) ->
    @parent = parent
    @leaf_container = if leaf_container then leaf_container else @parent.leaf_container
    @horizontal = undefined
    @x = x
    @y = y
    @children = []
    if @recurrence_possible(min_room_size)
      unless @horizontal
        split = Math.round( @x_size() * ((1/3)*Math.random()+(1/3)) )
        @children.push new Croissant.Generators.BSPTree(
          @,
          [x[0], x[0]+split],
          [y[0], y[1]],
          min_room_size
        ) 
        @children.push new Croissant.Generators.BSPTree(
          @,
          [x[0]+split, x[1]],
          [y[0], y[1]],
          min_room_size
        )
      else
        split = Math.round( @y_size() * ((1/3)*Math.random()+(1/3)) )
        @children.push new Croissant.Generators.BSPTree(
          @,
          [x[0], x[1]],
          [y[0], y[0]+split],
          min_room_size
        ) 
        @children.push new Croissant.Generators.BSPTree(
          @,
          [x[0], x[1]],
          [y[0]+split, y[1]],
          min_room_size
        )
    else
      @leaf_container.push new Croissant.Generators.BSPLeaf([x[0],x[1]],[y[0],y[1]])

  recurrence_possible: (room_size) =>
    if (@x_size() > 3*(room_size[0])+1 and @y_size() > 3*(room_size[1])+1)
      @horizontal = Math.random() > .5
      return true
    else
      if (@x_size() > 3*(room_size[0])+1)
        @horizontal = false
        return true
      else if (@y_size() > 3*(room_size[1])+1)
        @horizontal = true
        return true
    return false

  x_size: =>
    return Math.abs(@x[1] - @x[0])

  y_size: =>
    return Math.abs(@y[1] - @y[0])

class @Croissant.Generators.BSP

  @generate: (level, min_room_size) ->
    min_room_size_x = 0
    min_room_size_y = 0
    if min_room_size[0] and min_room_size[1]
      min_room_size_x = min_room_size[0]
      min_room_size_y = min_room_size[1]
    else
      min_room_size_x = if min_room_size[0] then min_room_size[0] else min_room_size
      min_room_size_y = min_room_size_x

    leaf_array = []
    root = undefined

    if (level.columns > 3*min_room_size_x+1 and level.rows > 3*min_room_size_y+1)
      root = new Croissant.Generators.BSPTree(
        null,
        [0, level.columns],
        [0, level.rows],
        [min_room_size_x, min_room_size_y],
        leaf_array)

    return { rooms: leaf_array, level: level }
