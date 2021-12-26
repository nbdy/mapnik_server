cmake_minimum_required(VERSION 3.20)
project(mapnik_server)

set(CMAKE_CXX_STANDARD 17)

add_executable(mapnik_server main.cpp)
target_link_libraries(mapnik_server mapnik icuuc)
