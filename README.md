# pony-img

*stbi_image* wrapper in Pony.

## Setup

Clone this repository in your project:

```sh
# Recommended
git submodule add https://github.com/adri326/pony-img

# Alternatively
git clone https://github.com/adri326/pony-img
```

### With installation

One way to use this library is to build it, then to install it on your system:

```sh
cd pony-img

# Create a build directory
mkdir build
cd build

# Make the project and install it; this will install a C wrapper around stb_image in your /local/lib directory, for pony to then use
cmake ..
make && sudo make install
```

Then, add `pony-img` to your `ponyc` path, and simply include it using `use "pony-img"`:

```sh
export PONY_PATH "${PONY_PATH}:pony-img"
ponyc
```

### Without installation

<!-- TODO: git submodule ifever it becomes needed -->

You will have to build the C wrapper, then ask Pony to link against it.
This may easily be done with `CMake`:

```cmake
cmake_minimum_required(VERSION 3.13)

# this is the only line you need to add if you already have a cmake project set up
include(pony-img/include.cmake)

set(PONY_PATH $ENV{PONY_PATH}:${PROJECT_SOURCE_DIR}/pony-img:${PROJECT_SOURCE_DIR}/build)

add_custom_target(
  your-project-name ALL
  COMMAND ponyc -o build --path ${PONY_PATH}
  WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
  DEPENDS pony_img_c
)
```

### Using `pony-stable`

```sh
stable add github adri326/pony-img

cd .deps/adri326/pony-img
mkdir build
cd build
cmake ..
make && sudo make install
```

## Usage

Simply include it and start using it right away!

```pony
use "pony-img" // That's it!

actor Main
  new create(env: Env) =>
    let image = Image.open("my-cat-picture.png") // 🐱
```
