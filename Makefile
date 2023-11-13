

all: target/debug/libgps_data.a bindings.h
	gcc -g -ggdb -O1 main.c target/debug/libgps_data.a -o main

bindings.h: src/lib.rs
	cargo build

target/debug/libgps_data.a: src/lib.rs
	cargo build
