use "../pony-img"
use "debug"

actor Main
  new create(env: Env) =>
    try
      let img = Image.load("../test/img.png")?
      Debug(img.width.string())
      Debug(img.height.string())
      Debug(img.channels.string())
      Debug(img.get_pixel(img.width / 2, img.height / 2, 2)._2.string())
      Debug(img.get_pixel_c(img.width / 2, img.height / 2, 2).string())
      let rgb = img.get_pixel_crgba(img.width / 2, img.height / 2)
      Debug(rgb._1.string() + ", " + rgb._2.string() + ", " + rgb._3.string() + ", " + rgb._4.string())
    else
      env.out.print("Couldn't read image :(")
    end
