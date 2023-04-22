PRJ_DIR = `pwd`
NAME = bare
XLEN = 32
TOOLCHAIN = riscv32-unknown-elf
CONFIG = P32CHAU1V000
IS_SIM = 1
CC = ${TOOLCHAIN}-gcc
AR = ${TOOLCHAIN}-ar
LD = ${TOOLCHAIN}-ld
CFLAGS = -O1 -nostartfiles -fstrict-volatile-bitfields -march=rv${XLEN}i
CFLAGS += -Woverflow 
CFLAGS += -DXLEN=${XLEN} -DCONFIG_${CONFIG} -DIS_SIM=${IS_SIM}
LIB_HERD_PATH = ../lib-herd
INCLUDE = -I${LIB_HERD_PATH}/src/
INCLUDE += -I${LIB_HERD_PATH}/src/pltf/
INCLUDE += -I${LIB_HERD_PATH}/src/sys/
ELF2HEX = ../../tools/elf2hex.py
BOOT_SECTIONS = --only-section .boot* --only-section .rodata* 
BOOT_OFFSET		= 0x00000000
ROM_SECTIONS 	= --only-section .text* --only-section .data*
ROM_OFFSET		= 0x04000000

export PRJ_DIR TOOLCHAIN CC AR CFLAGS

build-dir:
	mkdir -p ${PRJ_DIR}/obj
	mkdir -p ${PRJ_DIR}/lib
	mkdir -p ${PRJ_DIR}/elf
	mkdir -p ${PRJ_DIR}/hex
	mkdir -p ${PRJ_DIR}/list

libs: build-dir
	make -C ${LIB_HERD_PATH} all
	mv ${LIB_HERD_PATH}/lib/lib-herd.a lib/

elf: libs
	${CC} $(CFLAGS) ${INCLUDE} -c src/start.S -o obj/start.o
	${CC} $(CFLAGS) ${INCLUDE} -c src/main/init.c -o obj/init.o
	${CC} $(CFLAGS) ${INCLUDE} -c src/main/main.c -o obj/main.o
#	${LD} -static -T script.ld obj/*.o lib/*.a -o ${PRJ_DIR}/elf/${NAME}.elf
	${CC} $(CFLAGS) ${INCLUDE} -T script.ld obj/*.o lib/*.a -o ${PRJ_DIR}/elf/${NAME}.elf

list: elf
	${TOOLCHAIN}-objdump -D ${PRJ_DIR}/elf/${NAME}.elf -M numeric > ${PRJ_DIR}/list/${NAME}.list

hex-boot: list
	${TOOLCHAIN}-objcopy ${BOOT_SECTIONS} ${PRJ_DIR}/elf/${NAME}.elf ${PRJ_DIR}/elf/${NAME}.boot.elf
	python3 ${ELF2HEX} --input elf/${NAME}.boot.elf --output hex/${NAME}.boot8.hex --offset ${BOOT_OFFSET} --wide 16 --word 1
	python3 ${ELF2HEX} --input elf/${NAME}.boot.elf --output hex/${NAME}.boot32.hex --offset ${BOOT_OFFSET} --wide 32 --word 4
	python3 ${ELF2HEX} --input elf/${NAME}.boot.elf --output hex/${NAME}.boot64.hex --offset ${BOOT_OFFSET} --wide 32 --word 8

hex-rom: list
	${TOOLCHAIN}-objcopy ${ROM_SECTIONS} ${PRJ_DIR}/elf/${NAME}.elf ${PRJ_DIR}/elf/${NAME}.rom.elf
	python3 ${ELF2HEX} --input elf/${NAME}.rom.elf --output hex/${NAME}.rom8.hex --offset ${ROM_OFFSET} --wide 16 --word 1
	python3 ${ELF2HEX} --input elf/${NAME}.rom.elf --output hex/${NAME}.rom32.hex --offset ${ROM_OFFSET} --wide 32 --word 4
	python3 ${ELF2HEX} --input elf/${NAME}.rom.elf --output hex/${NAME}.rom64.hex --offset ${ROM_OFFSET} --wide 32 --word 8

hex: hex-boot hex-rom

clean:
	make -C ${LIB_HERD_PATH} clean
	rm -rf obj/
	rm -rf lib/
	rm -rf elf/
	rm -rf list/
	rm -rf hex/
