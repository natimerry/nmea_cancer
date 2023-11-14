 
CFLAGS= -Wno-discarded-qualifiers -Werror -Wall -Wextra 
MIPFLAGS= ${CFLAGS} -mhard-float -falign-functions=16 -march=mips64r2 -mno-shared
CC=gcc
MIPSCC=mipsel-linux-gnu-gcc-10
CARGO= cargo +nightly

TARGET=mipsel-unknown-linux-musl

NATIVE_LIB_TARGETS=target/debug/libgps_data.a 
MIPSEL_LIB_TARGEST=target/${TARGET}/debug/libgps_data.a 



all:main_mips 
	echo "Built successfully"

main_mips: ${NATIVE_LIB_TARGETS} bindings.h Cargo.toml main.c
	${CC} -g -ggdb -O1 main.c ${NATIVE_LIB_TARGETS} ${CFLAGS} -o main

release: target/debug/libgps_data.a bindings.h
	${CC} -O3 -fno-stack-protector main.c target/debug/libgps_data.a ${CFLAGS} -o main 

mips: ${MIPSEL_LIB_TARGEST} bindings.h
	${MIPSCC} -O3 -fno-stack-protector -pipe main.c ${MIPSEL_LIB_TARGEST} ${MIPFLAGS} -static -o main_mips 


target/${TARGET}/debug/libgps_data.a:
	export RUSTFLAGS='-C -opt-level=1 target-feature=+crt-static'
	${CARGO} build --target=${TARGET} -Z build-std

bindings.h: src/lib.rs
	${CARGO} build

target/debug/libgps_data.a: src/lib.rs
	${CARGO} build

qemu:
	qemu-mipsel -L . -E LD_PRELOAD=./lib/ld.so.1 -E LD_PRELOAD=./lib/libc.so.6 ./main_mips
	
clean:
	rm -rf target
	rm -rf bindings.h
	rm -rf main
	rm -rf main_mips