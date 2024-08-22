# Makefile for kernel

# Compiler, assembler, and linker
CC = i686-elf-gcc
AS = i686-elf-as
LD = i686-elf-ld
CFLAGS = -std=gnu99 -ffreestanding -O2 -Wall -Wextra
LDFLAGS = -ffreestanding -O2 -nostdlib -lgcc

# Directories
SRC_DIR = kernel
INCLUDE_DIR = kernel/include
OBJ_DIR = obj
BIN_DIR = bin

# Output binary
KERNEL_BIN = $(BIN_DIR)/kernel.bin

# Source files
KERNEL_SOURCES = $(wildcard $(SRC_DIR)/*.c $(SRC_DIR)/*/*.c)
KERNEL_OBJECTS = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(KERNEL_SOURCES))
BOOT_OBJECT = $(OBJ_DIR)/boot.o

# All targets
all: $(KERNEL_BIN)

# Assemble boot.s
$(BOOT_OBJECT): boot.s
	@mkdir -p $(OBJ_DIR)
	$(AS) boot.s -o $(BOOT_OBJECT)

# Compile kernel
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -I$(INCLUDE_DIR) -c $< -o $@

# Link kernel
$(KERNEL_BIN): $(BOOT_OBJECT) $(KERNEL_OBJECTS)
	@mkdir -p $(BIN_DIR)
	$(LD) -T linker.ld -o $(KERNEL_BIN) $(BOOT_OBJECT) $(KERNEL_OBJECTS) $(LDFLAGS)

# Clean files
clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

# Run kernel in QEMU
run: all
	qemu-system-i386 -kernel $(KERNEL_BIN)

.PHONY: all clean run
