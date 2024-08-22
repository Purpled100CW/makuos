CC = i686-elf-gcc
AS = i686-elf-as
LD = i686-elf-gcc  
CFLAGS = -ffreestanding -m32 -Wall -Wextra -nostdlib -nostartfiles -nodefaultlibs -Iinclude
LDFLAGS = -T linker/linker.ld -nostdlib -nostartfiles

QEMU = qemu-system-i386

SRC_DIR = kernel
OBJ_DIR = build
BUILD_DIR = build

C_SRC = $(wildcard $(SRC_DIR)/*.c)
ASM_SRC = $(wildcard $(SRC_DIR)/*.s)
SRC = $(C_SRC) $(ASM_SRC)
OBJ = $(addprefix $(OBJ_DIR)/, $(notdir $(C_SRC:.c=.o) $(ASM_SRC:.s=.o)))

HEADERS = $(wildcard include/kernel/*.h)

KERNEL = $(BUILD_DIR)/kernel.bin

all: $(KERNEL)

$(KERNEL): $(OBJ)
	$(CC) $(LDFLAGS) -o $@ $(OBJ)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(HEADERS)
	@mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.s
	@mkdir -p $(OBJ_DIR)
	$(AS) -o $@ $<

clean:
	rm -rf $(OBJ_DIR) $(KERNEL)

qemu:
	$(QEMU) -kernel $(BUILD_DIR)/kernel.bin