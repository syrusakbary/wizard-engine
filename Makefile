all: x86-linux x86-64-linux jvm

.PHONY: clean x86-linux x86-64-linux jvm wave
clean:
	rm -f TAGS bin/*
	cp scripts/* bin/

x86-linux: bin/spectest.x86-linux bin/wizeng.x86-linux bin/unittest.x86-linux bin/objdump.x86-linux

x86-64-linux: bin/spectest.x86-64-linux bin/wizeng.x86-64-linux bin/unittest.x86-64-linux bin/objdump.x86-64-linux

jvm: bin/spectest.jvm bin/wizeng.jvm bin/unittest.jvm bin/objdump.jvm

wave: bin/spectest.wasm bin/wizeng.wasm bin/unittest.wasm bin/objdump.wasm

ENGINE=src/engine/*.v3 src/engine/v3/*.v3 src/util/*.v3
JIT=src/engine/compiler/*.v3
X86_64=src/engine/x86-64/*.v3
WAVE=src/wave/*.v3
WASI=src/wasi/*.v3
WASI_X86_64_LINUX=src/wasi/x86-64-linux/*.v3
JAWA=src/jawa/*.v3
WIZENG=src/wizeng.main.v3
OBJDUMP=$(ENGINE) src/objdump.main.v3
SPECTEST=$(ENGINE) test/spectest/*.v3 test/spectest.main.v3
UNITTEST=$(ENGINE) $(JAWA) test/unittest/*.v3 test/spectest/*.v3 test/unittest.main.v3
WIZENG=$(ENGINE) $(WAVE) $(WASI) src/wizeng.main.v3

TAGS: $(ENGINE) $(WIZENG) $(WAVE) $(WASI) $(JAWA) $(SPECTEST) $(UNITTEST) $(WASI_X86_64_LINUX) $(X86_64)
	vctags -e $(ENGINE) $(WAVE) $(WASI) $(JAWA) $(SPECTEST) $(UNITTEST) $(WASI_X86_64_LINUX) $(X86_64)

# JVM targets
bin/unittest.jvm: $(UNITTEST)
	./build.sh unittest jvm

bin/spectest.jvm: $(SPECTEST)
	./build.sh spectest jvm

bin/wizeng.jvm: $(WIZENG) 
	./build.sh wizeng jvm

bin/objdump.jvm: $(OBJDUMP)
	./build.sh objdump jvm

# WAVE targets
bin/unittest.wasm: $(UNITTEST)
	./build.sh unittest wave

bin/spectest.wasm: $(SPECTEST)
	./build.sh spectest wave

bin/wizeng.wasm: $(WIZENG)
	./build.sh wizeng wave

bin/objdump.wasm: $(OBJDUMP)
	./build.sh objdump wave

# x86-linux targets
bin/unittest.x86-linux: $(UNITTEST)
	./build.sh unittest x86-linux

bin/spectest.x86-linux: $(SPECTEST)
	./build.sh spectest x86-linux

bin/wizeng.x86-linux: $(WIZENG)
	./build.sh wizeng x86-linux

bin/objdump.x86-linux: $(OBJDUMP)
	./build.sh objdump x86-linux

# x86-64-linux targets
bin/unittest.x86-64-linux: $(UNITTEST) $(X86_64) $(JIT)
	./build.sh unittest x86-64-linux

bin/spectest.x86-64-linux: $(SPECTEST) $(X86_64) $(JIT)
	./build.sh spectest x86-64-linux

bin/wizeng.x86-64-linux: $(WIZENG) $(wASI_X86_64_LINUX) $(X86_64) $(JIT)
	./build.sh wizeng x86-64-linux

bin/objdump.x86-64-linux: $(OBJDUMP) $(X86_64)
	./build.sh objdump x86-64-linux

# interpreter targets
bin/unittest.int: $(SPECTEST)
	./build.sh unittest int

bin/spectest.int: $(SPECTEST)
	./build.sh spectest int

bin/wizeng.int: $(WIZENG)
	./build.sh wizeng int

bin/objdump.int: $(OBJDUMP)
	./build.sh objdump int
