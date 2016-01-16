cmake_minimum_required(VERSION 3.4)

project(LB/optional
	VERSION 0.0.0
	LANGUAGES CXX
)
set(CMAKE_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX}/${PROJECT_NAME}/${PROJECT_VERSION})

add_library(optional INTERFACE)
#set_property(TARGET optional PROPERTY CXX_STANDARD 11)
target_compile_options(optional
	INTERFACE
		"-std=c++11"
)
target_include_directories(optional
	INTERFACE
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
		$<INSTALL_INTERFACE:include>
)

install(
	TARGETS
		optional
	EXPORT optional
)
install(
	EXPORT optional
	DESTINATION cmake
	NAMESPACE LB::
)
install(
	FILES
		"optional.hpp"
	DESTINATION include/${PROJECT_NAME}
)

enable_testing()

add_executable(test-basic
	"test/basic.cpp"
)
target_link_libraries(test-basic
	PUBLIC
		optional
)
add_test(
	NAME basic
	COMMAND test-basic
)
