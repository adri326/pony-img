use "lib:pony_img_c"

use @pony_img_get_error[Pointer[U8 val] ref]()

use @pony_img_new[PonyImageRaw](width: U32, height: U32, channels: U32, r: U8, g: U8, b: U8, a: U8)
use @pony_img_load_image[PonyImageRaw](uri: Pointer[U8 val] tag, required_channels: U32)
use @pony_img_destroy_image[None](img: PonyImageRaw)
use @pony_img_get_data[Pointer[U8]](img: PonyImageRaw)

use @pony_img_get_size[USize](img: PonyImageRaw)
use @pony_img_get_width[U32](img: PonyImageRaw)
use @pony_img_get_height[U32](img: PonyImageRaw)
use @pony_img_get_channels[U32](img: PonyImageRaw)

use @pony_img_read[U8](img: PonyImageRaw, x: U32, y: U32, channel: U32)
use @pony_img_get_rgb[U32](img: PonyImageRaw, x: U32, y: U32)
use @pony_img_get_rgba[U32](img: PonyImageRaw, x: U32, y: U32)

use @pony_img_write_png[Bool](uri: Pointer[U8 val] tag, img: PonyImageRaw, compression: U8)
use @pony_img_write_bmp[Bool](uri: Pointer[U8 val] tag, img: PonyImageRaw)
use @pony_img_write_tga[Bool](uri: Pointer[U8 val] tag, img: PonyImageRaw)

primitive _PonyImageRaw
type PonyImageRaw is Pointer[_PonyImageRaw ref] val

primitive ImageError
  """
    Gives you the error that stb_image is having, ifever it has one.
  """
  fun apply(): (String val | None) =>
    recover val
      let str = @pony_img_get_error()
      if str.is_null() then
        None
      else
        String.from_cstring(str)
      end
    end

class Image
  """
    The Image class, which is the bulk of this project. It allows for communication with stb_image in order to read and write data from/to an image.

    You can load an Image from a file by doing `Image.load(<uri>, [required_channels])`.

    This class will mirror the data within the image in an array, though modifying it will modify the C data array.

    **Note:** As per my recommendation on bringing performance and safety back together when working with numbers, some of the functions (namely `get_pixel_...`) will return a tupple, whose last element is a `Bool`.
    This element's purpose is to let you know whether or not the function failed, without raising any slow-to-handle error or using boxed numbers.
    It is of your responsibility to use it wisely. The error value of the other terms of these tuples will always be 0.
  """
  let _raw: PonyImageRaw
  let _data: Array[U8] ref

  let width: U32
  let height: U32
  let channels: U32

  new create(width': U32, height': U32, channels': U32 = 3, color: (U8 | (U8, U8, U8)) = 0, alpha: U8 = 255) =>
    width = width'
    height = height'
    channels = channels'

    let color' = match color
    | let v: U8 => (v, v, v)
    | (let r: U8, let g: U8, let b: U8) => (r, g, b)
    end

    _raw = @pony_img_new(width, height, channels, color'._1, color'._2, color'._3, alpha)
    _data = Array[U8].from_cpointer(@pony_img_get_data(_raw), @pony_img_get_size(_raw))

  new load(uri: String val, required_channels: U32 = 0)? =>
    """
    Load an image from a file
    """

    _raw = @pony_img_load_image(uri.cstring(), required_channels)
    if _raw.is_null() then
      error
    end

    width = @pony_img_get_width(_raw)
    height = @pony_img_get_height(_raw)
    channels = @pony_img_get_channels(_raw)

    _data = Array[U8].from_cpointer(@pony_img_get_data(_raw), @pony_img_get_size(_raw))

  fun get_pixel(x: U32, y: U32, channel: U32 = 0): (U8, Bool) =>
    """
    Get the pixel's value at the given coordinate and channel
    """

    if (x >= 0) and (y >= 0) and (x < width) and (y < height) then
      try
        (
          _data((
            ((x + (y * width)) * channels) + channel
          ).usize())?,
          true
        )
      else
        (0, false)
      end
    else
      (0, false)
    end

  fun get_pixel_c(x: U32, y: U32, channel: U32 = 0): U8 =>
    """
    C version of get_pixel; does the same, with less checks
    """
    if (x >= 0) and (y >= 0) and (x < width) and (y < height) then
      @pony_img_read(_raw, x, y, channel)
    else
      0
    end


  fun get_pixel_r(x: U32, y: U32): (U8, Bool) =>
    get_pixel(x, y, 0)

  fun get_pixel_cr(x: U32, y: U32): U8 =>
    @pony_img_read(_raw, x, y, 0)


  fun get_pixel_g(x: U32, y: U32): (U8, Bool) =>
    if (channels == 3) or (channels == 4) then
      get_pixel(x, y, 1)
    else
      get_pixel(x, y, 0)
    end

  fun get_pixel_cg(x: U32, y: U32): U8 =>
    if (channels == 3) or (channels == 4) then
      get_pixel_c(x, y, 1)
    else
      get_pixel_c(x, y, 0)
    end


  fun get_pixel_b(x: U32, y: U32): (U8, Bool) =>
    if (channels == 3) or (channels == 4) then
      get_pixel(x, y, 2)
    else
      get_pixel(x, y, 0)
    end

  fun get_pixel_cb(x: U32, y: U32): U8 =>
    if (channels == 3) or (channels == 4) then
      get_pixel_c(x, y, 2)
    else
      get_pixel_c(x, y, 0)
    end

  fun get_pixel_a(x: U32, y: U32): (U8, Bool) =>
    if channels == 2 then
      get_pixel(x, y, 1)
    elseif channels == 4 then
      get_pixel(x, y, 3)
    else
      (255, true)
    end

  fun get_pixel_ca(x: U32, y: U32): U8 =>
    if channels == 2 then
      get_pixel_c(x, y, 1)
    elseif channels == 4 then
      get_pixel_c(x, y, 3)
    else
      255
    end

  fun get_pixel_rgb(x: U32, y: U32): (U8, U8, U8, Bool) =>
    if (x >= 0) and (y >= 0) and (x < width) and (y < height) then
      if (channels == 3) or (channels == 4) then
        try
          let r = _data((
            ((x + (y * width)) * channels)
          ).usize())?
          let g = _data((
            ((x + (y * width)) * channels) + 1
          ).usize())?
          let b = _data((
            ((x + (y * width)) * channels) + 2
          ).usize())?
          (r, g, b, true)
        else
          (0, 0, 0, false)
        end
      else
        let c = get_pixel(x, y, 0)
        (c._1, c._1, c._1, c._2)
      end
    else
      (0, 0, 0, false)
    end

  fun get_pixel_crgb(x: U32, y: U32): (U8, U8, U8) =>
    """
    **Note:** This function only works on **big-endian** architectures
    """
    if (x >= 0) and (y >= 0) and (x < width) and (y < height) then
      let c = @pony_img_get_rgb(_raw, x, y)

      ((c % 256).u8(), ((c >> 8) % 256).u8(), ((c >> 16) % 256).u8())
    else
      (0, 0, 0)
    end

  fun get_pixel_rgba(x: U32, y: U32): (U8, U8, U8, U8, Bool) =>
    if (x >= 0) and (y >= 0) and (x < width) and (y < height) then
      if (channels == 3) or (channels == 4) then
        try
          let offset = ((x + (y * width)) * channels).usize()
          let r = _data(offset)?
          let g = _data(offset + 1)?
          let b = _data(offset + 2)?
          let a = if channels == 3 then 255 else
            _data(offset + 3)?
          end
          (r, g, b, a, true)
        else
          (0, 0, 0, 0, false)
        end
      else
        let c = get_pixel(x, y, 0)
        let a = get_pixel_a(x, y)
        (c._1, c._1, c._1, a._1, c._2 and a._2)
      end
    else
      (0, 0, 0, 0, false)
    end

  fun get_pixel_crgba(x: U32, y: U32): (U8, U8, U8, U8) =>
    """
    **Note:** This function only works on **big-endian** architectures
    """
    if (x >= 0) and (y >= 0) and (x < width) and (y < height) then
      let c = @pony_img_get_rgba(_raw, x, y)

      ((c % 256).u8(), ((c >> 8) % 256).u8(), ((c >> 16) % 256).u8(), ((c >> 24) % 256).u8())
    else
      (0, 0, 0, 0)
    end


  fun ref set_pixel(x: U32, y: U32, color: (U8 | (U8, U8, U8)), a: U8 = 255): Bool =>
    if (x >= 0) and (y >= 0) and (x < width) and (y < height) then // only set the pixel if it is in-bound
      let offset = ((x + (y * width)) * channels).usize() // position offset in the array

      if channels == 1 then // Y
        try
          _data(offset)? = match color
          | let v: U8 => v
          | (let r: U8, let g: U8, let b: U8) => (r + g + b) / 3
          end
          true
        else
          false
        end
      elseif channels == 2 then // YA
        try
          _data(offset)? = match color
          | let v: U8 => v
          | (let r: U8, let g: U8, let b: U8) => (r + g + b) / 3
          end
          _data(offset + 1)? = a
          true
        else
          false
        end
      elseif (channels == 3) or (channels == 4) then // RGB(A)
        let color' = match color
        | let v: U8 => (v, v, v)
        | (let r: U8, let g: U8, let b: U8) => (r, g, b)
        end

        if channels == 3 then // RGB
          try
            _data(offset)? = color'._1
            _data(offset + 1)? = color'._2
            _data(offset + 2)? = color'._3
            true
          else
            false
          end
        else // RGBA
          try
            _data(offset)? = color'._1
            _data(offset + 1)? = color'._2
            _data(offset + 2)? = color'._3
            _data(offset + 3)? = a
            true
          else
            false
          end
        end
      else
        false
      end
    else
      false
    end

  fun write(uri: String val)? =>
    """
      Write an Image to a file
    """
    let extension = uri.lower().trim(uri.size() - 4)
    if extension == ".png" then
      @pony_img_write_png(uri.cstring(), _raw, 8)
    elseif extension == ".bmp" then
      @pony_img_write_bmp(uri.cstring(), _raw)
    elseif extension == ".tga" then
      @pony_img_write_tga(uri.cstring(), _raw)
    else
      // idk that filetype :3
      error
    end

  fun _final() =>
    @pony_img_destroy_image(_raw)
