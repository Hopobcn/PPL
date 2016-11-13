
set(PPL_SOURCES
    pluginpath.cpp
    settings.cpp
    dataref.cpp
    messagewindow.cpp
    onscreendisplay.cpp
    owneddata.cpp
    logichandler.cpp
    texture.cpp
    overlaygauge.cpp
    log.cpp
    logwriter.cpp
    menuitem.cpp
    smoothed.cpp
    processor.cpp
    vertexbuffer.cpp
)

if (WITHSOUND)
    set(PPL_SOURCES
        ${PPL_SOURCES}
        alsoundbuffer.cpp
        alcontextmanager.cpp
        alcontextchanger.cpp
    )
endif (WITHSOUND)

if (WITHFREETYPE)
    set(PPL_SOURCES ${PPL_SOURCES} fotmgr.cpp)
endif (WITHFREETYPE)

if (WITHSERIALIZATION)
    set(PPL_SOURCES ${PPL_SOURCES} sharedobject.cpp)
endif (WITHSERIALIZATION)

add_library(PPL SHARED ${PPL_SOURCES})

target_include_directories(PPL PUBLIC "${XPLANE_INCLUDES_PATH}/XPLM" "${XPLANE_INCLUDES_PATH}/Widgets" "${XPLANE_INCLUDES_PATH}/Wrappers")
target_link_libraries(PPL ${GLEW_LIBRARIES})
qt5_use_modules(PPL Core Gui)

if(APPLE)
    set_property(TARGET PPL APPEND_STRING PROPERTY LINK_FLAGS
        "${CMAKE_SHARED_LINKER_FLAGS} -fPIC -fvisibility=hidden -bundle"
    )
elseif(UNIX)
    set_property(TARGET PPL APPEND_STRING PROPERTY LINK_FLAGS
        "${CMAKE_SHARED_LINKER_FLAGS} -rdynamic -nodefaultlibs -undefined_warning -fPIC -fvisibility=hidden"
    )
endif()

if ("${CMAKE_SYSTEM_NAME}" MATCHES "Windows")
    set_target_properties(PPL PROPERTIES LINK_FLAGS_DEBUG "/SUBSYSTEM:WINDOWS")
    set_target_properties(PPL PROPERTIES LINK_FLAGS_RELEASE "/SUBSYSTEM:WINDOWS")
endif()

