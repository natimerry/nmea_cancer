 
CFLAGS= -Wno-discarded-qualifiers -Werror -Wall
all: target/debug/libgps_data.a bindings.h
	gcc -g -ggdb -O1 main.c target/debug/libgps_data.a ${CFLAGS} -o main

release: target/debug/libgps_data.a bindings.h
	gcc -O3 -falign-functions=32 -fno-stack-protector main.c target/debug/libgps_data.a ${CFLAGS} -o main 

bindings.h: src/lib.rs
	cargo build

target/debug/libgps_data.a: src/lib.rs
	cargo build

clean:
	rm -rf target
	rm -rf bindings.h