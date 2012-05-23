@Croissant = {}

class @Croissant.Canvas

  constructor: (element, name, stack) ->
    @name = name
    @element = element
    @stack = stack
    @gridsize = stack.gridsize
    @size_x = stack.size_x
    @size_y = stack.size_y
    @context = element.getContext('2d')

  draw_grid: =>
    for pos_x in [0..(@size_x-1)]
      for pos_y in [0..(@size_y-1)]
        @context.strokeRect(pos_x*@gridsize, pos_y*@gridsize, @gridsize, @gridsize)

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
      throw 'Non-uniform grids!'
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
