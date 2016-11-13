#
# XPLANE SDK from github.com/leecbaker/xplane_sdk
#
add_subdirectory(xplane_sdk)
message(STATUS "--------------")
message(STATUS "XPLANE_INCLUDES_PATH ${XPLANE_INCLUDES_PATH}")
message(STATUS "XPLANE_LIBRARY_PATH  ${XPLANE_LIBRARY_PATH}")
message(STATUS "--------------")

if (WITHFREETYPE)
    if (WIN32)
        set(FREETYPE2_STATIC TRUE)
    else (WIN32)
        set(FREETYPE2_STATIC FALSE)
    endif (WIN32)
    add_subdirectory(freetype2)
endif (WITHFREETYPE)
