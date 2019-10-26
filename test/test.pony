use "../pony-img"
use "debug"
use "random"
use "collections"
use "time"

actor Main
  let env: Env
  new create(env': Env) =>
    env = env'
    try
      let img = recover ref Image.load("../test/img.png")? end
      img_info(img)
      modify_img(img)
    else
      env.out.print("Couldn't read image :(")
    end

  fun img_info(img: Image box) =>
    Debug(img.width.string())
    Debug(img.height.string())
    Debug(img.channels.string())
    Debug(img.get_pixel(img.width / 2, img.height / 2, 2)._2.string())
    Debug(img.get_pixel_c(img.width / 2, img.height / 2, 2).string())
    let rgb = img.get_pixel_crgba(img.width / 2, img.height / 2)
    Debug(rgb._1.string() + ", " + rgb._2.string() + ", " + rgb._3.string() + ", " + rgb._4.string())

  fun modify_img(img: Image ref) =>
    let new_img = Image(img.width, img.height, img.channels)

    let rng = XorOshiro128StarStar(Time.nanos())

    for y in Range[U32](0, img.height) do
      for x in Range[U32](0, img.width) do
        // for (almost) every pixel, choose a random neighbor and set the pixel to this neighbor's value instead
        if ((rng.next() % 16) < 12) and (x > 8) and (y > 8) and (x < (img.width - 8)) and (y < (img.height - 8)) then // .75 of probability

          let dx = (rng.next() % 16).i32() - 8
          let dy = (rng.next() % 16).i32() - 8
          let color = img.get_pixel_rgba((x.i32() + dx).u32(), (y.i32() + dy).u32())

          new_img.set_pixel(x, y, (color._1, color._2, color._3), color._4)
        else
          let color = img.get_pixel_rgba(x, y)
          new_img.set_pixel(x, y, (color._1, color._2, color._3), color._4)
        end
      end
    end

    try
      new_img.write("../test/out.png")?
    else
      env.out.print("Couldn't write image :(")
    end
