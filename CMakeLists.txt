cmake_minimum_required(VERSION 3.13)

project(pony_img_c
  VERSION 0.0.1
  DESCRIPTION "Mappings from C (using stb_image) to Pony"
)

set(HEADER_FILES
  src/flatten.h
  src/stb_image.h
)

set(SOURCE_FILES
  src/flatten.c
)

add_library(pony_img_c
  SHARED
  ${HEADER_FILES}
  ${SOURCE_FILES}
)

install(
  TARGETS pony_img_c
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  PUBLIC_HEADER DESTINATION include
  INCLUDES DESTINATION include
)
