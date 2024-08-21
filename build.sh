echo "Starting to build..."
i686-elf-as boot.s -o build/boot.o
echo "Boot.s Builded"
i686-elf-gcc -c kernel/kernel/kernel.c -o build/kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra -I kernel/include
echo "Kernel builded"
i686-elf-gcc -T linker.ld -o build/myos.bin -ffreestanding -O2 -nostdlib build/boot.o build/kernel.o -lgcc
echo "linker linked"
qemu-system-i386 -kernel build/myos.bin