#include "flatten_read.h"

const char* pony_img_get_error() {
  return stbi_failure_reason();
}

PonyImage* pony_img_load_image(const char* uri, const uint32_t required_channels) {
  PonyImage* img = malloc(sizeof(PonyImage));
  img->data = stbi_load(uri, &img->width, &img->height, &img->channels, required_channels);

  if (img->data == NULL) {
    free(img);
    return NULL;
  } else {
    return img;
  }
}

void pony_img_destroy_image(PonyImage* img) {
  if (img != NULL) {
    if (img->data != NULL) stbi_image_free(img->data);
    free(img);
  }
}

uint8_t pony_img_read(PonyImage* img, const uint32_t x, const uint32_t y, const uint32_t channel) {
  return img->data[(x + y * img->width) * img->channels + channel];
}

uint8_t* pony_img_get_data(PonyImage* img) {
  return img->data;
}

size_t pony_img_get_size(PonyImage* img) {
  return img->width * img->height * img->channels;
}

uint32_t pony_img_get_width(PonyImage* img) {
  return img->width;
}

uint32_t pony_img_get_height(PonyImage* img) {
  return img->height;
}

uint32_t pony_img_get_channels(PonyImage* img) {
  return img->channels;
}

uint32_t pony_img_get_rgb(PonyImage* img, const uint32_t x, const uint32_t y) {
  // It looks awful, I'm sorry for that

  if (img->channels == 1) {
    uint8_t c = img->data[x + y * img->width];
    return c | (c << 8) | (c << 16);
  } else if (img->channels == 2) {
    uint8_t c = img->data[(x + y * img->width) << 1];
    return c | (c << 8) | (c << 16);
  } else if (img->channels == 3) {
    size_t offset = (x + y * img->width) * 3;
    return img->data[offset] | img->data[offset + 1] << 8 | img->data[offset + 2] << 16;
  } else if (img->channels == 4) {
    return 0x00ffffff & ((uint32_t*)img->data)[x + y * img->width];
  } else return 0;
}

uint32_t pony_img_get_rgba(PonyImage* img, const uint32_t x, const uint32_t y) {
  // This one's worse D:

  if (img->channels == 1) {
    uint8_t c = img->data[x + y * img->width];
    return c | (c << 8) | (c << 16) | 0xff000000;
  } else if (img->channels == 2) {
    uint8_t c = img->data[(x + y * img->width) << 1];
    return c | (c << 8) | (c << 16) | (img->data[((x + y * img->width) << 1) + 1] << 24);
  } else if (img->channels == 3) {
    return 0x00ffffff & *((uint32_t*)img->data + (x + y * img->width) * 3) | 0xff000000;
  } else if (img->channels == 4) {
    return ((uint32_t*)img->data)[x + y * img->width];
  } else return 0;
}
