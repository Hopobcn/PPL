cmake_minimum_required(VERSION 2.8.8)
project(PPL C CXX)

# Policy CMP0043 introduced in cmake version 3.0 IGNORES the use of COMPILE_DEFINITIONS suffixed variables, e.g. COMPILE_DEFINITIONS_DEBUG
# Set to OLD behavior in versions >= 2.8.10 (first version where COMPILE_DEFNITIONS can be set using generator expressions)
if (POLICY CMP0043)
    message(STATUS "Set CMAKE policy CMP0043=OLD")
    cmake_policy(SET CMP0043 OLD)
endif()

option(STANDALONE   "Build PPL Stand Alone" OFF)
option(WITHSOUND    "Build PPL with sound" OFF)
option(WITHFREETYPE "Build PPL with FreeType2" OFF)
option(WITHSERIALIZATION "Build PPL with Serialization" OFF)

#option(UNIT_TESTS      "Turn on Unit Tests" OFF)
#option(COVERAGE_TESTS  "Turn on Coverage Tests" OFF)
#option(COVERAGE_UPLOAD "Upload generated coveralls json to coverall.io" ON)

# set CMAKE_PREFIX_PATH to automatically find dependences
# specify custom cmake find modules
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH}
                      ${CMAKE_SOURCE_DIR}/cmake
                     )#${CMAKE_SOURCE_DIR}/cmake/coveralls-cmake/cmake)
message(STATUS "CMAKE_MODULE_PATH: ${CMAKE_MODULE_PATH}")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/share)

include(cmake/CMake_build_options.cmake)

add_subdirectory(external)
add_subdirectory(src)
if (UNIT_TESTS)
    add_subdirectory(tests)
endif ()

if (COVERAGE_TESTS)
    set(COVERAGE_SRCS main/main.cpp
                      include/Car.hpp
                      include/Client.hpp
                      include/LicensePlate.hpp
                      include/Phone.hpp
                      include/Reference.hpp
                      include/Stock.hpp
    )

    # Create coveralls target
    coveralls_setup("${COVERAGE_SRCS}" ${COVERAGE_UPLOAD} "${PROJECT_SOURCE_DIR}/cmake/coveralls-cmake/cmake")
endif (COVERAGE_TESTS)
