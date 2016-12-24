# Makefile for a Maya plugin.

UNAME = $(shell uname)

##################################
# Platform specific build settings
##################################


ARCH          = $(shell uname -m)
C++           = g++
BUILDDIR      = Build/$(ARCH)

NO_TRANS_LINK =

ifeq ($(UNAME), Linux)

# LINUX
CFLAGS        = -DLINUX -D_BOOL -DREQUIRE_IOSTREAM -DBits64_ -DLINUX_64 -fPIC
C++FLAGS      = $(CFLAGS) -Wno-deprecated -fno-gnu-keywords
LD            = $(C++) $(NO_TRANS_LINK) $(C++FLAGS) -Wl,-Bsymbolic -shared
INCLUDES      = -I. -I$(MAYA_LOCATION)/include -I/opt/X11/include
DEBUGFLAGS    = -g -gstabs+
TARGET        = spReticle.so

# OSX
else

DEVSDK = MacOSX10.11.sdk

CFLAGS        =  -D_BOOL -DREQUIRE_IOSTREAM  -DOSMac_ -DOSMac_MachO_ \
     -mmacosx-version-min=10.9  -Wno-switch-enum -Wno-switch \
     -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/$(DEVSDK) \
     -Wno-switch-enum -Wno-switch -DLTC_NO_ASM \
   # -stdlib=libstdc++ #-lstdc++ #-std=c++0x

C++FLAGS      = $(CFLAGS) 
LD            =  $(C++) -bundle -framework AGL -framework OpenGL  \
    #-F/System/Library/Frameworks
MAYA_LOCATION = /Applications/Autodesk/maya2014
INCLUDES      = -I. -I$(MAYA_LOCATION)/devkit/include/  
DEBUGFLAGS    = -g
TARGET        = spReticle.bundle

LIBS          = -L$(MAYA_LOCATION)/Maya.app/Contents/MacOS \
                        -lOpenMayaRender -lOpenMayaUI -lOpenMaya -lFoundation -lOpenMayaAnim
endif


debug: spReticleLoc.o $(TARGET)
opt: spReticleLoc.o $(TARGET)

debug: BUILDDIR = Build/$(ARCH)-debug
debug: CFLAGS += $(DEBUGFLAGS)

opt: BUILDDIR = Build/$(ARCH)-opt
opt: CFLAGS += -O3

.cpp.o:
	-mkdir -p $(BUILDDIR)
	$(C++) -c $(INCLUDES) $(C++FLAGS) -o $(BUILDDIR)/$@ $<

plugins: \
    $(TARGET)

clean:
	-rm -f Build/*/*.o

Clean:
	-rm -rf Build

##################
# Specific Rules #
##################
GPURenderer.o : util.h GPURenderer.h GPURenderer.cpp
OpenGLRenderer.o : font.h OpenGLRenderer.h OpenGLRenderer.cpp
V2Renderer.o : V2Renderer.h V2Renderer.cpp
spReticleLoc.o : defines.h util.h spReticleLoc.h spReticleLoc.cpp

$(TARGET): GPURenderer.o OpenGLRenderer.o V2Renderer.o spReticleLoc.o
	-@mkdir -p $(BUILDDIR)
	-@rm -f $@
	$(LD) -o $(BUILDDIR)/$@ $(BUILDDIR)/GPURenderer.o $(BUILDDIR)/OpenGLRenderer.o $(BUILDDIR)/V2Renderer.o $(BUILDDIR)/spReticleLoc.o $(LIBS) -lOpenMaya -lOpenMayaRender -lOpenMayaUI
	@echo ""
	@echo "###################################################"
	@echo successfully compiled $@ into $(BUILDDIR)
	@echo $(CURDIR)/$(BUILDDIR)/$@
	@echo ""

