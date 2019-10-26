#ifndef PONY_IMG
#define PONY_IMG

#include <inttypes.h>
#include <stdlib.h>
#include <string.h>

struct PonyImage {
  uint32_t width;
  uint32_t height;
  uint32_t channels;
  uint8_t* data;
};

typedef struct PonyImage PonyImage;

PonyImage* pony_img_new(const uint32_t width, const uint32_t height, const uint32_t channels, const uint8_t r, const uint8_t g, const uint8_t b, const uint8_t a);

PonyImage* pony_img_copy(PonyImage* source);

#endif
// PONY_IMG
