# I know nothing about scons, waf, or autoconf. Sorry.
NODE_PREFIX := $(shell node --vars | egrep ^NODE_PREFIX: | cut -c14-)
NODE_PLATFORM := $(shell node --vars | egrep -o 'DPLATFORM="[^"]+' | cut -c12-)
NODE_BITS := $(shell file --dereference `which node` | egrep -o '[0-9]{2}-bit' | cut -c-2)

CPPFLAGS = -Wall -Wno-deprecated-declarations -I$(NODE_PREFIX)/include -I$(NODE_PREFIX)/include/node
ifdef DEBUG
	CPPFLAGS += -ggdb -O0
else
	CPPFLAGS += -g -O3 -minline-all-stringops
endif

ifeq ($(NODE_PLATFORM), linux)
	# SJLJ in linux = hangs & segfaults
	CPPFLAGS += -DCORO_UCONTEXT
	COROUTINE_SO = coroutine.so
endif
ifeq ($(NODE_PLATFORM), darwin)
	# UCONTEXT in os x = hangs & segfaults :(
	CPPFLAGS += -DCORO_SJLJ
	COROUTINE_SO = coroutine.dylib
endif
