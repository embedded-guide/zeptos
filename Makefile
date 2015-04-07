PROJECT = zeptos
SRC := $(shell find src -name *.c -print)

GCC_PREFIX = arm-none-eabi-
CC = $(GCC_PREFIX)gcc
OBJCOPY = $(GCC_PREFIX)objcopy
OBJDUMP = $(GCC_PREFIX)objdump
SIZE = $(GCC_PREFIX)size
COPY = sudo cp

vpath %.c src
TARGET = build/$(PROJECT)
OBJ = $(SRC:src/%.c=build/%.o)

CPU_FLAGS = -mcpu=cortex-m4 -mthumb

CC_FLAGS = -std=gnu99 $(CPU_FLAGS) -Wall -ffreestanding -fno-common -fstack-usage
LD_FLAGS = -nostdlib -Wl,-Map=$(TARGET).map -T link.ld

all: $(TARGET).bin

$(OBJ): Makefile

$(TARGET).elf: $(OBJ) link.ld
	$(CC) $(LD_FLAGS) -o $@ $(OBJ)
	$(SIZE) -Ax $@

$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary $< $@

build/%.o: %.c
	@mkdir -p `dirname $@`
	$(CC) -c $(CC_FLAGS) -o $@ $<

.PHONY: clean
clean:
	rm -rf build

.PHONY: flash
flash: $(TARGET).bin
	@if [ -z "$(MBED_PATH)" ]; then echo You must define MBED_PATH as the path to the root of the mbed mass storage; exit 1; fi
	$(COPY) $< $(MBED_PATH)
