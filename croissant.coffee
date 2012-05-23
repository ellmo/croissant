class @Croissant

  constructor: (canvas_div, size_x, size_y) ->
    @canvas_div = $(canvas_div)
    unless @canvas_div.css('position') is 'relative'
      @canvas_div.css('position', 'relative') 
    @canvas_height = parseInt @canvas_div.css('height')
    @canvas_width = parseInt @canvas_div.css('width')
    @size_x = size_x
    @size_y = if size_y then size_y else size_x
    if (@size_x is @size_y) and (@canvas_height is @canvas_width)
      @gridsize = @canvas_width / size_x
    else
      @gridsize =
        x: (@canvas_width / @size_x)
        y: (@canvas_height / @size_y)
    @layers = @add_canvases()

  add_canvases: =>
    layer_names = ['effects', 'foreground', 'grid', 'background']
    layers = {}
    for layer_name in layer_names
      layer = $("<canvas id=#{layer_name} height=#{@canvas_height} width=#{@canvas_width} z-index=#{layer_names.indexOf(layer_name)} style='position: absolute; left: 0; top: 0;'>")[0]
      @canvas_div.append(layer)
      layers[layer_name] = {layer: $(layer), context: layer.getContext('2d')}
    return layers

  draw_grid: (layer = 'grid') =>
    context = @layers[layer].context
    for pos_x in [0..(@size_x-1)]
      for pos_y in [0..(@size_y-1)]
        context.strokeRect(pos_x*@gridsize, pos_y*@gridsize, @gridsize, @gridsize)