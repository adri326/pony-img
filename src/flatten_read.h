/*!
I call these files "flatteners", as I use them to access complex data structures with "flat" functions, which I can use back in pony.
*/

#ifndef PONY_IMG_FLATTEN_READ_H
#define PONY_IMG_FLATTEN_READ_H

#include <stdlib.h>
#include <inttypes.h>
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"
#include "pony_image.h"

//! Returns stb's error message
const char* pony_img_get_error();

//! Loads an image and returns it as a PonyImage
PonyImage* pony_img_load_image(const char* uri, const uint32_t required_channels);

//! Destroys a PonyImage
void pony_img_destroy_image(PonyImage* img);

//! Returns the data array
uint8_t* pony_img_get_data(PonyImage* img);

//! Returns the value of a one pixel
uint8_t pony_img_read(PonyImage* img, const uint32_t x, const uint32_t y, const uint32_t channel);

//! Returns the length of the data array
size_t pony_img_get_size(PonyImage* img);

//! Returns the width of the image
uint32_t pony_img_get_width(PonyImage* img);

//! Returns the height of the image
uint32_t pony_img_get_height(PonyImage* img);

//! Returns the number of channels that the image has
uint32_t pony_img_get_channels(PonyImage* img);

//! Returns an RGB value as a 32-bit integer
uint32_t pony_img_get_rgb(PonyImage* img, const uint32_t x, const uint32_t y);

//! Returns an RGBA value as a 32-bit integer
uint32_t pony_img_get_rgba(PonyImage* img, const uint32_t x, const uint32_t y);


#endif
// PONY_IMG_FLATTEN_READ_H
