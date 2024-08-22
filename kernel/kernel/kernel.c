// kernel/kernel/kernel.c

#include <kernel/paging.h>
#include <kernel/terminal.h>

void kernel_main(void) {
    terminal_initialize();

    paging_init();
    enable_paging();

    terminal_writestring("Paging enabled!\n");
}
