// kernel/kernel/paging.c

#include <kernel/paging.h>

static page_directory_entry_t page_directory[PAGE_DIRECTORY_SIZE] __attribute__((aligned(PAGE_SIZE)));
static page_table_entry_t page_tables[PAGE_DIRECTORY_SIZE][PAGE_TABLE_SIZE] __attribute__((aligned(PAGE_SIZE)));

void paging_init(void) {
    for (int i = 0; i < PAGE_DIRECTORY_SIZE; i++) {
        for (int j = 0; j < PAGE_TABLE_SIZE; j++) {
            page_tables[i][j].present = 0;
            page_tables[i][j].rw = 0;
            page_tables[i][j].user = 0;
            page_tables[i][j].address = 0;
        }
        page_directory[i].present = 1;
        page_directory[i].rw = 1;
        page_directory[i].user = 0;
        page_directory[i].address = ((uint32_t) page_tables[i] >> 12);
    }
}

void enable_paging(void) {
    // Set up the CR3 register to point to the page directory
    asm volatile("mov %0, %%cr3" :: "r"(&page_directory));

    // Enable paging by setting the PG bit in CR0
    uint32_t cr0;
    asm volatile("mov %%cr0, %0" : "=r"(cr0));
    cr0 |= 0x80000000;  
    asm volatile("mov %0, %%cr0" :: "r"(cr0));
}
