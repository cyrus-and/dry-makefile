# https://github.com/cyrus-and/dry-makefile

# Copyright (c) 2019 Andrea Cardaci <cyrus.and@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

.PHONY: clean cleanall install uninstall

# optionally include the user configuration file, otherwise the user Makefile
# can include this one
-include config.Makefile

# default values (all the sources are executables)
SOURCES      ?= $(wildcard *.c *.C *.cc *.cpp)
EXECUTABLES  ?= $(SOURCES)
INSTALL_PATH ?= /usr/local/bin

# gather environment information
EXTENSION    := $(suffix $(firstword $(SOURCES)))
OBJECTS      := $(SOURCES:$(EXTENSION)=.o)
LIB_OBJECTS  := $(filter-out $(EXECUTABLES:$(EXTENSION)=.o),$(OBJECTS))
TARGETS      := $(EXECUTABLES:$(EXTENSION)=)
DEPENDENCIES := $(SOURCES:$(EXTENSION)=.d)

# choose and configure the right compiler according to the extension used (this
# is needed to link .o files of C++ sources)
CC := $(firstword $(COMPILE$(EXTENSION)))

# set compiler and linker flags (they must be recursively expansible)
CFLAGS   = -MMD $(COMPILER_FLAGS)
CXXFLAGS = -MMD $(COMPILER_FLAGS)
LDFLAGS  = $(LINKER_FLAGS)
LDLIBS   = $(LIBRARIES)

# build all the targets using profiles
BUILD_PROFILES ?= default
$(BUILD_PROFILES): $(SETUP_HOOK) $(TARGETS)
$(TARGETS): %: %.o $(LIB_OBJECTS)

# make the first profile the default target
.DEFAULT_GOAL := $(firstword $(BUILD_PROFILES))

# remove building files
clean: $(CLEANUP_HOOK)
	$(RM) $(OBJECTS) $(DEPENDENCIES)

# also remove targets
cleanall: clean
	$(RM) $(TARGETS)

# copy the targets to the install location
install:
	install $(TARGETS) $(INSTALL_PATH)

# remove the targets from the install location
uninstall:
	$(RM) $(addprefix $(INSTALL_PATH)/,$(notdir $(TARGETS)))

# use the dependency files if already present
-include $(DEPENDENCIES)
