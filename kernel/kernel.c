#include "kernel/kernel.h"

void kernel_main(void) 
{
    terminal_initialize();
    terminal_writestring("Hello, kernel World!\n");
}
