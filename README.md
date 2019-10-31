# DRY Makefile

Opinionated Makefile for simple C/C++ projects.

## Complete annotated example

Fetch the DRY Makefile:

```
wget -Os https://raw.githubusercontent.com/cyrus-and/dry-makefile/master/Makefile
```

Create the following `config.Makefile`:

```makefile
# all the source files
SOURCES := $(wildcard src/*.c)

# executable source files
EXECUTABLES := src/main.c

# compiler and linker flags
COMPILER_FLAGS := -Wall -pedantic
LINKER_FLAGS   := -pthread

# additional shared libraries
LIBRARIES := -lm

# directory where `make install` copies the targets
INSTALL_PATH := /opt/bin

# declare the build profiles starting from the default rule, when omitted only
# the `default` profile is present which uses the variables defined so far
BUILD_PROFILES := release debug

# configure the variables for each declared profile
release: COMPILER_FLAGS += -O3 -Os
debug:   COMPILER_FLAGS += -ggdb3 -Werror -DDEBUG

# list of rules to be set as prerequisites of each build
SETUP_HOOK := setup
setup:
    @echo Fetching auxiliary files...

# list of rules to be set as prerequisites of the `clean` rule
CLEANUP_HOOK := cleanup
cleanup:
    @echo Removing auxiliary files...

# place additional custom rules here...
```

Alternatively, the above can be placed in a Makefile file on its own and the DRY Makefile can be included with (place this below the configuration):

```makefile
include /path/to/dry-makefile/Makefile
```

Then use it like this:

- `make` builds the default profile;
- `make <name>` builds the `<name>` profile;
- `make clean` removes all the building files but not the targets;
- `make cleanall` removes all the building files including the targets;
- `make install` copies the targets to the install location;
- `make uninstall`  removes the targets from the install location.

DRY Makefile uses `.d` dependency files, those files can be safely ignored by the version-control system.
