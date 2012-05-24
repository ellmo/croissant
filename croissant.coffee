@Croissant =
  Generators: {}

class @Croissant.Level

  constructor: (size) ->
    @tiles = []
    if size[0] and size[1]
      @rows = size[0]
      @columns = size[1]
    else
      @rows = if size[0] then size[0] else size
      @columns = @rows
    for row in [0..(@rows-1)]
      @tiles.push []
      for col in [0..(@columns-1)]
        @tiles[row][col] = new Croissant.MapTile('wall')
    

class @Croissant.MapTile

  constructor: (terrain) ->
    @terrain = terrain


class @Croissant.Canvas

  constructor: (element, name, stack) ->
    @name = name
    @element = element
    @stack = stack
    @gridsize = stack.gridsize
    @size_x = stack.size_x
    @size_y = stack.size_y
    @context = element.getContext('2d')

  draw_grid: (color = null) =>
    prev_stroke_style = @context.strokeStyle
    @context.strokeStyle = color if color
    for pos_x in [0..(@size_x-1)]
      for pos_y in [0..(@size_y-1)]
        @context.strokeRect(pos_x*@gridsize, pos_y*@gridsize, @gridsize, @gridsize)
    @context.strokeStyle = prev_stroke_style

  clear: () =>
    @context.clearRect(0, 0, @element.width, @element.height)

  draw_object: =>
    @context

class @Croissant.CanvasStack

  constructor: (canvas_div, size, layers) ->
    @canvas_div = $(canvas_div)
    @canvas_height = parseInt @canvas_div.css('height')
    @canvas_width = parseInt @canvas_div.css('width')
    if size[0] and size[1]
      @size_x = size[0]
      @size_y = size[1]
    else
      @size_x = if size[0] then size[0] else size
      @size_y = @size_x
    if (@size_x is @size_y) and (@canvas_height is @canvas_width)
      @gridsize = @canvas_width / @size_x
    else
      throw 'Non-uniform grid!'
    @layers = {}

    unless @canvas_div.css('position') is 'relative'
      @canvas_div.css('position', 'relative') 
    @add_canvases(layers)

  add_canvases: (layer_names) =>
    for layer_name in layer_names
      layer = $("<canvas id=#{layer_name} height=#{@canvas_height} width=#{@canvas_width} z-index=#{-layer_names.indexOf(layer_name)} style='position: absolute; left: 0; top: 0;'>")[0]
      @canvas_div.append(layer)
      @layers[layer_name] = new Croissant.Canvas(layer, layer_name, @)
    false
