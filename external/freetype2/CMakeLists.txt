include(ExternalProject)

# Download and install FreeType2

ExternalProject_Add(
    buildlfreetype2
    #--Download step--------
    GIT_REPOSITORY http://git.sv.nongnu.org/freetype/freetype2.git
    GIT_TAG VER-2-7
    #--Update/Patch step----
    #--Configure step-------
    CMAKE_ARGS -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
               -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
               -DFREETYPE2_STATIC=${FREETYPE2_STATIC}
    #--Build step-----------
    #--Install step---------
    INSTALL_COMMAND ""
    #--Test step------------
    #--Output logging-------
    #--Custom targets-------
)

ExternalProject_Get_Property(buildfreetype2 SOURCE_DIR)
ExternalProject_Get_Property(buildfreetype2 BINARY_DIR)

set(FREETYPE2_INCLUDE_DIR ${SOURCE_DIR}/include)
set(FREETYPE2_LIBRARY_DIR ${BINARY_DIR})
set(FREETYPE2_LIB         ${FREETYPE2_LIBRARY_DIR}/${CMAKE_FIND_LIBRARY_PREFIXES}freetype2.a)
set(FREETYPE2_LIBRARY     freetype2)
add_library(${FREETYPE2_LIB} STATIC IMPORTED GLOBAL)
set_property(TARGET ${FREETYPE2_LIBRARY} PROPERTY IMPORTED_LOCATION ${FREETYPE1_LIB})
add_dependencies(${FREETYPE2_LIBRARY} buildfreetype2)

