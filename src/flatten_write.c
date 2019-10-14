#include "flatten_write.h"

bool pony_img_write_png(const char* uri, PonyImage* img, const uint8_t compression) {
  if (stbi_write_png_compression_level != compression) {
    stbi_write_png_compression_level = compression;
  }
  stbi_write_png(uri, img->width, img->height, img->channels, img->data, 0);
}

bool pony_img_write_bmp(const char* uri, PonyImage* img) {
  stbi_write_bmp(uri, img->width, img->height, img->channels, img->data);
}

bool pony_img_write_tga(const char* uri, PonyImage* img) {
  stbi_write_tga(uri, img->width, img->height, img->channels, img->data);
}
