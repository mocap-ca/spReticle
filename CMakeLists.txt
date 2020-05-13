cmake_minimum_required(VERSION 2.8)

project(SpReticle$ENV{MAYA_VERSION})

if ("$ENV{MAYA_VERSION}" STREQUAL "")
    message(FATAL_ERROR  "MAYA_VERSION IS NOT DEFINED")
endif()

if ("$ENV{DEVKIT_LOCATION}" STREQUAL "")
    message(FATAL_ERROR  "DEVKIT_LOCATION IS NOT DEFINED")
endif()

set(CMAKE_DEBUG_POSTFIX d)

include($ENV{DEVKIT_LOCATION}/cmake/pluginEntry.cmake)

set(SOURCE_FILES
       spReticleLoc.cpp
       V2Renderer.cpp
       OpenGLRenderer.cpp
       GPURenderer.cpp)
       
if (WIN32)
	set(PACKAGE_LIBS ${PACKAGE_LIBS} ws2_32.lib winmm.lib OpenGL32.lib)	
	set(CMAKE_SHARED_LINKER_FLAGS "/export:initializePlugin /export:uninitializePlugin")
endif()

set(LIBRARIES OpenMaya Foundation OpenMayaAnim OpenMayaFX OpenMayaRender OpenMayaUI )
       
       
build_plugin()