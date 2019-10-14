#ifndef PONY_IMG_FLATTEN_WRITE_H
#define PONY_IMG_FLATTEN_WRITE_H

#include <stdlib.h>
#include <inttypes.h>
#include <stdbool.h>
#include "pony_image.h" // grab the PonyImage declaration
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"

//! Write a PonyImage instance to a PNG file
bool pony_img_write_png(const char* uri, PonyImage* img, const uint8_t compression);

//! Write a PonyImage instance to a BMP file
bool pony_img_write_bmp(const char* uri, PonyImage* img);

//! Write a PonyImage instance to a TGA file
bool pony_img_write_tga(const char* uri, PonyImage* img);

#endif
// PONY_IMG_FLATTEN_WRITE_H
