# Croissant

A javaScript library for rogue-like game development.

*The Polish word for a 'croissant' is 'rogalik' which is also - understandably - a slang word for Roguelike games*

**Croissant requires jQuery and will most probably require underscore.js at some point**

## What do we have so far:

* ###Canvas initialization

  Meet the `Croissant.CanvasStack` class.

  > new CanvasStack( div_selector, number_of_tiles, layer_names_array )

  * **div_selector** - The output of random room generation algorithms is supposed to be displayed in a HTML5 Canvas element. You do **NOT**, however, create a `canvas` element for Croissant to do it's magic. You just give it a `div` with fixed `width` and `height` values and then you pass it's selector to Croissant's `CanvasStack` constructor.

  * **number_of_tiles** - How many tiles is the canvas supposed to display. You can pass a single int, which will be used as both horizontal and vertical tile number, or you can pass a two int array if you plan on displaying in an irregular (_not square_) canvas.

  * **layer_names_array** - An array of strings representing layer names. Croissant will create a separate `Croissant.Canvas` object for each, so you can have a multi-layered picture.

  **Example:**

  Define a `div` element for Croissant's `CanvasStack` to move in.

  ...thus:

  > \<div id="cro" style="width: 420px; height: 420px;">\</div>

  To initialize a 32x32 tile canvas, with two layers, call the following:

  > c = new Croissant.CanvasStack( $('#cro'), 32, ['layer1','the_layer_two'] )

  You can grab a specific layer and draw a grid on it:

  > c.layers.layer1.draw_grid()

  And you can clear it:

  > c.layers.layer1.clear()

  You can also just hide it for the time being, by getting the actual `canvas`:

  > c.layers.layer1.element.hide()

* ###A level definition

  Meet the `Croissant.Level` class.

  > new Croissant.Level( size )

  **size** - The number of level's rows and columns. Again, you can pass an int for regular, square levels, or a two-element array for non-regulars.

  Nothing much else to see here.

* ###BSP room generation

  Meet the `Croissant.Generators.BSP` class

  > bsp = new Croissant.Generators.BSP.generate( level, min_room_size )

  ...which does not have a constructor, it only has a static method to generate a series of random-sized, rectangular rooms (_more like room outlines_) using a BSP algorithm.

  There's a good depiction of BSP's room-generation basics on [Roguebasin's development database](http://roguebasin.roguelikedevelopment.org/index.php/Basic_BSP_Dungeon_generation), if you don't know how it works.

  **level** - `Croissant.Level` object.

  **min_room_size** - The smallest allowed room for the generator. Again it takes an int or an `[int, int]` array.

##Let's do something fun:

  1. create a `div` element for Croissant

    > \<div id="cro" style="width: 420px; height: 420px;">\</div>

  2. Initialize a `CanvasStack` inside of it:

    > stack = new Croissant.CanvasStack( $('#cro'), 32, ['rooms'] )

  3. Create a `Level`

    > level = new Croissant.Level( 32 )

  4. Run a BSP generation algorithm and get an array of room definitions in return

    > rooms = new Croissant.Generators.BSP.generate( level, [5,5] )

  5. Draw the room outlines on a `Canvas` layer

    > stack.layers.rooms.draw_rooms( rooms )