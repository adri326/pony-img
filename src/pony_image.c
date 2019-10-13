#include "pony_image.h"

PonyImage* pony_img_new(const uint32_t width, const uint32_t height, const uint32_t channels, const uint8_t r, const uint8_t g, const uint8_t b, const uint8_t a) {
  PonyImage* res = (PonyImage*)malloc(sizeof(PonyImage));
  res->width = width;
  res->height = height;
  res->channels = channels;
  res->data = (uint8_t*)malloc(width * height * channels);
  for (uint32_t y = 0; y < height; y++) {
    for (uint32_t x = 0; x < width; x++) {
      size_t offset = (x + y * width) * channels;
      if (channels == 1) {
        res->data[offset] = r;
      } else if (channels == 2) {
        res->data[offset] = r;
        res->data[offset + 1] = a;
      } else if (channels == 3) {
        res->data[offset] = r;
        res->data[offset + 1] = g;
        res->data[offset + 2] = b;
      } else if (channels == 4) {
        res->data[offset] = r;
        res->data[offset + 1] = g;
        res->data[offset + 2] = b;
        res->data[offset + 3] = a;
      }
    }
  }

  return res;
}
