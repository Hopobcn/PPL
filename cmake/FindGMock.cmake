include(ExternalProject)

set_directory_properties(PROPERTIRES EP_PREFIX ${CMAKE_BINARY_DIR}/ext/gmock)

# Download and install GoogleMock
ExternalProject_Add(
    googlemock
    #--Download step-------------
    URL https://googlemock.googlecode.com/files/gmock-1.7.0.zip
    #URL_HASH SHA1=TODO
    #--Update/Patch step----------
    #--Configure step-------------
    CMAKE_ARGS -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    -DBUILD_SHARED_LIBS=OFF
    -Dgmock_build_tests=OFF
    #--Build step-----------------
    #--Install step--------------- (DISABLED)
    INSTALL_COMMAND ""
    #--Test step------------------
    #--Output logging-------------
    #--Custom targets-------------
)

# Specify include dir
ExternalProject_Get_Property(googlemock SOURCE_DIR)
set(GMOCK_INCLUDE_DIR ${SOURCE_DIR}/include)
set(GTEST_INCLUDE_DIR ${SOURCE_DIR}/gtest/include)

ExternalProject_Get_Property(googlemock BINARY_DIR)

# Library GMock
set(GMOCK_LIBRARY_PATH ${BINARY_DIR})
set(GMOCK_LIB ${BINARY_DIR}/${CMAKE_FIND_LIBRARY_PREFIXES}gmock.a)
set(GMOCK_LIBRARY gmock)
add_library(${GMOCK_LIBRARY} STATIC IMPORTED GLOBAL)
set_property(TARGET ${GMOCK_LIBRARY} PROPERTY IMPORTED_LOCATION ${GMOCK_LIB})
add_dependencies(${GMOCK_LIBRARY} googlemock)

# Library GTest
set(GTEST_LIBRARY_PATH ${BINARY_DIR}/gtest)
set(GTEST_LIB ${BINARY_DIR}/gtest/${CMAKE_FIND_LIBRARY_PREFIXES}gtest.a)
set(GTEST_MAIN_LIB ${BINARY_DIR}/gtest/${CMAKE_FIND_LIBRARY_PREFIXES}gtest_main.a)
set(GTEST_LIBRARY gtest)
set(GTEST_MAIN_LIBRARY gtest-main)
set(GTEST_BOTH_LIBRARIES gtest-both)
add_library(${GTEST_LIBRARY} STATIC IMPORTED GLOBAL)
add_library(${GTEST_MAIN_LIBRARY} STATIC IMPORTED GLOBAL)
add_library(${GTEST_BOTH_LIBRARIES} STATIC IMPORTED GLOBAL)
set_property(TARGET ${GTEST_LIBRARY} PROPERTY IMPORTED_LOCATION ${GTEST_LIB})
set_property(TARGET ${GTEST_MAIN_LIBRARY} PROPERTY IMPORTED_LOCATION ${GTEST_MAIN_LIB})
set_property(TARGET ${GTEST_BOTH_LIBRARIES} PROPERTY IMPORTED_LOCATION ${GTEST_LIB} ${GTEST_MAIN_LIB})
add_dependencies(${GTEST_LIBRARY} googlemock)
add_dependencies(${GTEST_MAIN_LIBRARY} googlemock)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GMock
    FOUND_VAR GMOCK_FOUND
    REQUIRED_VARS GMOCK_LIBRARY GMOCK_INCLUDE_DIR GTEST_LIBRARY GTEST_MAIN_LIBRARY GTEST_BOTH_LIBRARIES GTEST_INCLUDE_DIR
    VERSION_VAR GMOCK_VERSION
    FAIL_MESSAGE "GMock & GTest NOT FOUND")