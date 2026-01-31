######## Makefile for RISC-V ########
# For ASM Project

# --------------------------------
# Project name
PROJECT?=ProjectRV

# Build directory
BUILD_DIR?=build

# Source files for ASM (.s)
SRCS_S?=$(wildcard *.s)

# Program
PROGRAM?=${BUILD_DIR}/${PROJECT}

# Bin (objcopy of program)
BINFILE?=${BUILD_DIR}/${PROJECT}.bin

# Dump (objdump of program, disassembly)
DMPFILE?=${BUILD_DIR}/${PROJECT}.dump

# Assembler
AS_BIN:=riscv-none-elf-as

# Tool objcopy
OBJCOPY?=riscv-none-elf-objcopy

# Tool objdump
OBJDUMP?=riscv-none-elf-objdump

# Flags for assemble
AS_FLAGS?=

# Flags for objcopy
OBJCOPY_FLAGS?=-O binary

# Flags for objdump
OBJDUMP_FLAGS?=-D

# --------------------------------
# Notification at the end of the task
define NOTIFY_DONE
@echo "|========> Makefile [$@]: Done"
@echo ""
endef

# --------------------------------
# Declare phony tasks
.PHONY: default dump clean

# Generate bin file
default: ${BUILD_DIR} ${BINFILE}
	${NOTIFY_DONE}

# Generate dump file
dump: ${BUILD_DIR} ${DMPFILE}
	${NOTIFY_DONE}

# Clean build directory
clean:
	rm -r -v -I ${BUILD_DIR}
	${NOTIFY_DONE}

# --------------------------------
# Create build directory
${BUILD_DIR}:
	mkdir -p ${BUILD_DIR}
	${NOTIFY_DONE}

# Generate bin file
${BINFILE}: ${PROGRAM}
	${OBJCOPY} ${OBJCOPY_FLAGS}	$< $@
	${NOTIFY_DONE}

# Generate dump file
${DMPFILE}: ${PROGRAM}
	${OBJDUMP} ${OBJDUMP_FLAGS} -S $< > $@
	${NOTIFY_DONE}

# Assemble asm source file to program
${PROGRAM}: ${SRCS_S} | ${BUILD_DIR}
	${AS_BIN} ${AS_FLAGS} $< -o $@
