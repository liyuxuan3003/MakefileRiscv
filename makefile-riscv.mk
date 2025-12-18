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

# Link object files to program
${PROGRAM}: ${OBJS}
	${CC_BIN} ${LDFLAGS} -o $@ $^
	${NOTIFY_DONE}

# Compile c source file to object file 
${BUILD_DIR}/%.o: %.c
	${CCBIN} ${CFLAGS} -o $@ -c $<
	${NOTIFY_DONE}
	
# Compile cpp source file to object file
${BUILD_DIR}/%.o: %.cpp
	${CXXBIN} ${CXXFLAGS} -o $@ -c $<
	${NOTIFY_DONE}

# Create c source file dependence file
${BUILD_DIR}/%.d: %.c
	${CCBIN} -M ${CFLAGS} $< -o $@
	sed -r -e 's|$*\.o[ :]*|${BUILD_DIR}/$*.o $@: |g' -i $@
	${NOTIFY_DONE}

# Build directory should be order only prerequest of dependence file
${DEPS}: | ${BUILD_DIR}

# Include dependence file if goal is not clean or clean-all
ifeq ($(filter clean ${MAKECMDGOALS}),)
sinclude ${DEPS}
endif
