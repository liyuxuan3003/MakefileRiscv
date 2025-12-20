######## Makefile for RISC-V ########

# --------------------------------
# Project name
PROJECT?=ProjectRiscv

# Build directory
BUILD_DIR?=build

# Compiler
CC_BIN:=riscv-none-elf-gcc

# Flags for compile
CC_FLAGS?=

# Flags for link
LD_FLAGS?=

# Tool objcopy
OBJCOPY?=riscv-none-elf-objcopy

# Flags for objcopy
OBJCOPY_FLAGS?=-O binary

# Source files for C (.c)
SRCS_C?=$(wildcard *.c)

# Source files for ASM (.s)
SRCS_S?=$(wildcard *.s)

# Object files (.o)
OBJS?=$(addprefix ${BUILD_DIR}/,$(SRCS_C:.c=.o) $(SRCS_S:.s=.o))

# Dependence files (.d)
DEPS?=$(OBJS:.o=.d)

# Program
PROGRAM?=${BUILD_DIR}/${PROJECT}

# Bin
BINFILE?=${BUILD_DIR}/${PROJECT}.bin

# --------------------------------
# Notification at the end of the task
define NOTIFY_DONE
@echo "|========> Makefile [$@]: Done"
@echo ""
endef

# --------------------------------
# Declare phony tasks
.PHONY: default clean

# Generate bin file
default: ${BUILD_DIR} ${BINFILE}
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

# Link object files to program
${PROGRAM}: ${OBJS}
	${CC_BIN} ${LD_FLAGS} -o $@ $^
	${NOTIFY_DONE}

# Compile c source file to object file 
${BUILD_DIR}/%.o: %.c | ${BUILD_DIR}
	${CC_BIN} ${CC_FLAGS} -o $@ -c $<
	${NOTIFY_DONE}

# Compile asm source file to object file 
${BUILD_DIR}/%.o: %.s | ${BUILD_DIR}
	${CC_BIN} ${CC_FLAGS} -o $@ -c $<
	${NOTIFY_DONE}

# Create c source file dependence file
${BUILD_DIR}/%.d: %.c | ${BUILD_DIR}
	${CC_BIN} -M ${CC_FLAGS} $< -o $@
	sed -r -e 's|$*\.o[ :]*|${BUILD_DIR}/$*.o $@: |g' -i $@
	${NOTIFY_DONE}

# Include dependence file if goal is not clean
ifeq ($(filter clean,${MAKECMDGOALS}),)
sinclude ${DEPS}
endif
