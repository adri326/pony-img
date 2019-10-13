#include "flatten_write.h"

bool pony_img_write_png(const char* uri, PonyImage* img, const uint8_t compression) {
  if (stbi_write_png_compression_level != compression) {
    stbi_write_png_compression_level = compression;
  }
  stbi_write_png(uri, img->width, img->height, img->channels, img->data, 0);
}
