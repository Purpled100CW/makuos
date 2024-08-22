# Define the compiler and flags
CC = i686-elf-gcc
AS = i686-elf-as
LD = i686-elf-gcc  # Use gcc for linking
CFLAGS = -ffreestanding -m32 -Wall -Wextra -nostdlib -nostartfiles -nodefaultlibs -Iinclude
LDFLAGS = -T linker/linker.ld -nostdlib -nostartfiles

QEMU = qemu-system-i386

# Define directories
SRC_DIR = kernel
OBJ_DIR = build
BUILD_DIR = build

# Define the source files and object files
C_SRC = $(wildcard $(SRC_DIR)/*.c)
ASM_SRC = $(wildcard $(SRC_DIR)/*.s)
SRC = $(C_SRC) $(ASM_SRC)
OBJ = $(addprefix $(OBJ_DIR)/, $(notdir $(C_SRC:.c=.o) $(ASM_SRC:.s=.o)))

# Define header files
HEADERS = $(wildcard include/kernel/*.h)

# Define the output file
KERNEL = $(BUILD_DIR)/kernel.bin

# Default target
all: $(KERNEL)

# Rule to build the kernel binary
$(KERNEL): $(OBJ)
	$(CC) $(LDFLAGS) -o $@ $(OBJ)

# Rule to compile C source files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(HEADERS)
	@mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Rule to assemble assembly source files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.s
	@mkdir -p $(OBJ_DIR)
	$(AS) -o $@ $<

# Clean rule
clean:
	rm -rf $(OBJ_DIR) $(KERNEL)

qemu:
	$(QEMU) -kernel $(BUILD_DIR)/kernel.bin