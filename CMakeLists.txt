#cmake_minimum_required(VERSION 3.1)

project(optional)

ADD_BII_TARGETS()

#set_property(TARGET ${BII_BLOCK_TARGET} PROPERTY CXX_STANDARD 11)
target_compile_options(${BII_BLOCK_TARGET} INTERFACE "-std=c++11")
