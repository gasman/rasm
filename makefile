CC=emcc
EXEC=rasm.js

CFLAGS=-lm -o $(EXEC)
CFLAGS_OPT = $(CFLAGS) -O2 -sEXPORTED_FUNCTIONS=_RasmAssembleInfo,_RasmFreeInfoStruct,_malloc,_free -sEXPORTED_RUNTIME_METHODS=ccall,cwrap,getValue,UTF8ToString -sASSERTIONS -sINITIAL_MEMORY=33554432
CFLAGS_DBG = $(CFLAGS) -g -pthread -lefence
CFLAGS_3RD = $(CFLAGS) -g -pthread -DNO_3RD_PARTIES

SRC_APUDIR=./apultra-master/src
SRC_LZSADIR=./lzsa-master/src
SRC_ZX0DIR=./ZX0-main/src

APU_FLAGS=-c -O3 -fomit-frame-pointer -I$(SRC_LZSADIR)/libdivsufsort/include -I$(SRC_APUDIR)

APU_OBJ =$(SRC_APUDIR)/expand.o
APU_OBJ+=$(SRC_APUDIR)/matchfinder.o
APU_OBJ+=$(SRC_APUDIR)/shrink.o
APU_OBJ+=$(SRC_APUDIR)/libdivsufsort/lib/divsufsort.o
APU_OBJ+=$(SRC_APUDIR)/libdivsufsort/lib/divsufsort_utils.o
APU_OBJ+=$(SRC_APUDIR)/libdivsufsort/lib/sssort.o
APU_OBJ+=$(SRC_APUDIR)/libdivsufsort/lib/trsort.o

LZSA_FLAGS=-c -O3 -fomit-frame-pointer -I$(SRC_LZSADIR)/libdivsufsort/include -I$(SRC_LZSADIR)

LZSA_OBJ =$(SRC_LZSADIR)/dictionary.o
LZSA_OBJ+=$(SRC_LZSADIR)/expand_block_v1.o
LZSA_OBJ+=$(SRC_LZSADIR)/expand_block_v2.o
LZSA_OBJ+=$(SRC_LZSADIR)/expand_context.o
LZSA_OBJ+=$(SRC_LZSADIR)/expand_inmem.o
LZSA_OBJ+=$(SRC_LZSADIR)/frame.o
LZSA_OBJ+=$(SRC_LZSADIR)/matchfinder.o
LZSA_OBJ+=$(SRC_LZSADIR)/shrink_block_v1.o
LZSA_OBJ+=$(SRC_LZSADIR)/shrink_block_v2.o
LZSA_OBJ+=$(SRC_LZSADIR)/shrink_context.o
LZSA_OBJ+=$(SRC_LZSADIR)/shrink_inmem.o
LZSA_OBJ+=$(SRC_LZSADIR)/stream.o

ZX0_FLAGS=-c -O2 -I$(SRC_ZX0DIR)
ZX0_OBJ =$(SRC_ZX0DIR)/optimize.o
ZX0_OBJ+=$(SRC_ZX0DIR)/compress.o
ZX0_OBJ+=$(SRC_ZX0DIR)/memory.o

.PHONY: prod third debug clean

default: prod

third:
	$(CC) rasm.c $(CFLAGS_3RD)

debug:
	$(CC) $(SRC_ZX0DIR)/optimize.c $(ZX0_FLAGS)           -o $(SRC_ZX0DIR)/optimize.o
	$(CC) $(SRC_ZX0DIR)/compress.c $(ZX0_FLAGS)           -o $(SRC_ZX0DIR)/compress.o
	$(CC) $(SRC_ZX0DIR)/memory.c $(ZX0_FLAGS)             -o $(SRC_ZX0DIR)/memory.o

	$(CC) $(SRC_APUDIR)/expand.c $(APU_FLAGS)                                -o $(SRC_APUDIR)/expand.o
	$(CC) $(SRC_APUDIR)/matchfinder.c $(APU_FLAGS)                           -o $(SRC_APUDIR)/matchfinder.o
	$(CC) $(SRC_APUDIR)/shrink.c $(APU_FLAGS)                                -o $(SRC_APUDIR)/shrink.o

	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/divsufsort.c $(APU_FLAGS)         -o $(SRC_APUDIR)/libdivsufsort/lib/divsufsort.o
	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/divsufsort_utils.c $(APU_FLAGS)   -o $(SRC_APUDIR)/libdivsufsort/lib/divsufsort_utils.o
	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/sssort.c $(APU_FLAGS)             -o $(SRC_APUDIR)/libdivsufsort/lib/sssort.o
	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/trsort.c $(APU_FLAGS)             -o $(SRC_APUDIR)/libdivsufsort/lib/trsort.o

	$(CC) $(SRC_LZSADIR)/matchfinder.c $(LZSA_FLAGS)       -o $(SRC_LZSADIR)/matchfinder.o
	$(CC) $(SRC_LZSADIR)/dictionary.c $(LZSA_FLAGS)        -o $(SRC_LZSADIR)/dictionary.o
	$(CC) $(SRC_LZSADIR)/expand_block_v1.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/expand_block_v1.o
	$(CC) $(SRC_LZSADIR)/expand_block_v2.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/expand_block_v2.o
	$(CC) $(SRC_LZSADIR)/expand_context.c $(LZSA_FLAGS)    -o $(SRC_LZSADIR)/expand_context.o
	$(CC) $(SRC_LZSADIR)/expand_inmem.c $(LZSA_FLAGS)      -o $(SRC_LZSADIR)/expand_inmem.o
	$(CC) $(SRC_LZSADIR)/frame.c $(LZSA_FLAGS)             -o $(SRC_LZSADIR)/frame.o
	$(CC) $(SRC_LZSADIR)/shrink_block_v1.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/shrink_block_v1.o
	$(CC) $(SRC_LZSADIR)/shrink_block_v2.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/shrink_block_v2.o
	$(CC) $(SRC_LZSADIR)/shrink_context.c $(LZSA_FLAGS)    -o $(SRC_LZSADIR)/shrink_context.o
	$(CC) $(SRC_LZSADIR)/shrink_inmem.c $(LZSA_FLAGS)      -o $(SRC_LZSADIR)/shrink_inmem.o
	$(CC) $(SRC_LZSADIR)/stream.c $(LZSA_FLAGS)            -o $(SRC_LZSADIR)/stream.o

	$(CC) rasm.c $(CFLAGS_DBG) $(APU_OBJ) $(LZSA_OBJ) $(ZX0_OBJ)

prod:
	$(CC) $(SRC_ZX0DIR)/optimize.c $(ZX0_FLAGS)           -o $(SRC_ZX0DIR)/optimize.o
	$(CC) $(SRC_ZX0DIR)/compress.c $(ZX0_FLAGS)           -o $(SRC_ZX0DIR)/compress.o
	$(CC) $(SRC_ZX0DIR)/memory.c $(ZX0_FLAGS)             -o $(SRC_ZX0DIR)/memory.o

	$(CC) $(SRC_APUDIR)/expand.c $(APU_FLAGS)                                -o $(SRC_APUDIR)/expand.o
	$(CC) $(SRC_APUDIR)/matchfinder.c $(APU_FLAGS)                           -o $(SRC_APUDIR)/matchfinder.o
	$(CC) $(SRC_APUDIR)/shrink.c $(APU_FLAGS)                                -o $(SRC_APUDIR)/shrink.o

	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/divsufsort.c $(APU_FLAGS)         -o $(SRC_APUDIR)/libdivsufsort/lib/divsufsort.o
	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/divsufsort_utils.c $(APU_FLAGS)   -o $(SRC_APUDIR)/libdivsufsort/lib/divsufsort_utils.o
	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/sssort.c $(APU_FLAGS)             -o $(SRC_APUDIR)/libdivsufsort/lib/sssort.o
	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/trsort.c $(APU_FLAGS)             -o $(SRC_APUDIR)/libdivsufsort/lib/trsort.o

	$(CC) $(SRC_LZSADIR)/matchfinder.c $(LZSA_FLAGS)       -o $(SRC_LZSADIR)/matchfinder.o
	$(CC) $(SRC_LZSADIR)/dictionary.c $(LZSA_FLAGS)        -o $(SRC_LZSADIR)/dictionary.o
	$(CC) $(SRC_LZSADIR)/expand_block_v1.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/expand_block_v1.o
	$(CC) $(SRC_LZSADIR)/expand_block_v2.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/expand_block_v2.o
	$(CC) $(SRC_LZSADIR)/expand_context.c $(LZSA_FLAGS)    -o $(SRC_LZSADIR)/expand_context.o
	$(CC) $(SRC_LZSADIR)/expand_inmem.c $(LZSA_FLAGS)      -o $(SRC_LZSADIR)/expand_inmem.o
	$(CC) $(SRC_LZSADIR)/frame.c $(LZSA_FLAGS)             -o $(SRC_LZSADIR)/frame.o
	$(CC) $(SRC_LZSADIR)/shrink_block_v1.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/shrink_block_v1.o
	$(CC) $(SRC_LZSADIR)/shrink_block_v2.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/shrink_block_v2.o
	$(CC) $(SRC_LZSADIR)/shrink_context.c $(LZSA_FLAGS)    -o $(SRC_LZSADIR)/shrink_context.o
	$(CC) $(SRC_LZSADIR)/shrink_inmem.c $(LZSA_FLAGS)      -o $(SRC_LZSADIR)/shrink_inmem.o
	$(CC) $(SRC_LZSADIR)/stream.c $(LZSA_FLAGS)            -o $(SRC_LZSADIR)/stream.o

	$(CC) rasm.c $(CFLAGS_OPT) $(APU_OBJ) $(LZSA_OBJ) $(ZX0_OBJ)
	strip $(EXEC)

reload:
	$(CC) rasm.c $(CFLAGS_OPT) $(APU_OBJ) $(LZSA_OBJ) $(ZX0_OBJ)
	strip $(EXEC)

release:
	$(CC) $(SRC_ZX0DIR)/optimize.c $(ZX0_FLAGS)           -o $(SRC_ZX0DIR)/optimize.o
	$(CC) $(SRC_ZX0DIR)/compress.c $(ZX0_FLAGS)           -o $(SRC_ZX0DIR)/compress.o
	$(CC) $(SRC_ZX0DIR)/memory.c $(ZX0_FLAGS)             -o $(SRC_ZX0DIR)/memory.o

	$(CC) $(SRC_APUDIR)/expand.c $(APU_FLAGS)                                -o $(SRC_APUDIR)/expand.o
	$(CC) $(SRC_APUDIR)/matchfinder.c $(APU_FLAGS)                           -o $(SRC_APUDIR)/matchfinder.o
	$(CC) $(SRC_APUDIR)/shrink.c $(APU_FLAGS)                                -o $(SRC_APUDIR)/shrink.o

	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/divsufsort.c $(APU_FLAGS)         -o $(SRC_APUDIR)/libdivsufsort/lib/divsufsort.o
	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/divsufsort_utils.c $(APU_FLAGS)   -o $(SRC_APUDIR)/libdivsufsort/lib/divsufsort_utils.o
	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/sssort.c $(APU_FLAGS)             -o $(SRC_APUDIR)/libdivsufsort/lib/sssort.o
	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/trsort.c $(APU_FLAGS)             -o $(SRC_APUDIR)/libdivsufsort/lib/trsort.o

	$(CC) $(SRC_LZSADIR)/matchfinder.c $(LZSA_FLAGS)       -o $(SRC_LZSADIR)/matchfinder.o
	$(CC) $(SRC_LZSADIR)/dictionary.c $(LZSA_FLAGS)        -o $(SRC_LZSADIR)/dictionary.o
	$(CC) $(SRC_LZSADIR)/expand_block_v1.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/expand_block_v1.o
	$(CC) $(SRC_LZSADIR)/expand_block_v2.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/expand_block_v2.o
	$(CC) $(SRC_LZSADIR)/expand_context.c $(LZSA_FLAGS)    -o $(SRC_LZSADIR)/expand_context.o
	$(CC) $(SRC_LZSADIR)/expand_inmem.c $(LZSA_FLAGS)      -o $(SRC_LZSADIR)/expand_inmem.o
	$(CC) $(SRC_LZSADIR)/frame.c $(LZSA_FLAGS)             -o $(SRC_LZSADIR)/frame.o
	$(CC) $(SRC_LZSADIR)/shrink_block_v1.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/shrink_block_v1.o
	$(CC) $(SRC_LZSADIR)/shrink_block_v2.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/shrink_block_v2.o
	$(CC) $(SRC_LZSADIR)/shrink_context.c $(LZSA_FLAGS)    -o $(SRC_LZSADIR)/shrink_context.o
	$(CC) $(SRC_LZSADIR)/shrink_inmem.c $(LZSA_FLAGS)      -o $(SRC_LZSADIR)/shrink_inmem.o
	$(CC) $(SRC_LZSADIR)/stream.c $(LZSA_FLAGS)            -o $(SRC_LZSADIR)/stream.o
	$(CC) rasm.c $(CFLAGS_OPT) $(APU_OBJ) $(LZSA_OBJ) $(ZX0_OBJ)
	strip $(EXEC)
	./upx --brute rasm.exe

clean:
	rm -rf *.o

