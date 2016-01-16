optional [![travis](https://travis-ci.org/LB--/optional.svg?branch=optional)](https://travis-ci.org/LB--/optional)
========
My personal implementation of `std::optional`/`boost::optional`, just for fun.

## Usage
### CMake
From the `cmake` directory, copy the `FindLB` directory to a place in your `CMAKE_MODULE_PATH`.
Then, add `find_package(LB/optional REQUIRED)` to your CMake script.
You may need to set the CMake variable `LB/optional_ROOT` if you installed to a nonstandard location.
Finally, link to the `LB::optional` imported target with `target_link_libraries()`.

### C++
First `#include <LB/optional/optional.hpp>`, and then bug LB to finish this TODO.
