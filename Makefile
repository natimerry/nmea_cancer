 
CFLAGS= -Wno-discarded-qualifiers -Werror -Wall
CC=gcc
MIPSCC=mipsel-linux-gnu-gcc-10
CARGO= cargo +nightly

TARGET=mipsel-unknown-linux-gnu

NATIVE_LIB_TARGETS=target/debug/libgps_data.a 
MIPSEL_LIB_TARGEST=target/${TARGET}/debug/libgps_data.a 



all: ${NATIVE_LIB_TARGETS} bindings.h
	${CC} -g -ggdb -O1 main.c ${NATIVE_LIB_TARGETS} ${CFLAGS} -o main

release: target/debug/libgps_data.a bindings.h
	${CC} -O3 -falign-functions=32 -fno-stack-protector main.c target/debug/libgps_data.a ${CFLAGS} -o main 

mips: ${MIPSEL_LIB_TARGEST} bindings.h
	${MIPSCC} -g -ggdb -O1 main.c ${MIPSEL_LIB_TARGEST} ${CFLAGS} -o main_mips


target/${TARGET}/debug/libgps_data.a:
	export RUSTFLAGS='-C -opt-level=1'
	${CARGO} build --target=${TARGET} -Z build-std

bindings.h: src/lib.rs
	${CARGO} build

target/debug/libgps_data.a: src/lib.rs
	${CARGO} build

clean:
	rm -rf target
	rm -rf bindings.h
	rm -rf main
	rm -rf main_mips