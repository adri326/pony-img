set(HEADER_FILES
  src/flatten_read.h
  src/flatten_write.h
  src/stb_image.h
  src/stb_image_write.h
  src/pony_image.h
)

set(SOURCE_FILES
  src/flatten_read.c
  src/flatten_write.c
  src/pony_image.c
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
