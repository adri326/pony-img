#ifndef PONY_IMG
#define PONY_IMG

struct PonyImage {
  uint32_t width;
  uint32_t height;
  uint32_t channels;
  uint8_t* data;
};

typedef struct PonyImage PonyImage;

#endif
// PONY_IMG
