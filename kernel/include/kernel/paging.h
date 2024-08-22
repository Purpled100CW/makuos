// kernel/include/paging.h

/* Paging is the way computer can manage memory really efficiently.It divides it into small blocks named "pages".
And keeps few of them in the RAM.While others are on slower storage
PT (PageTable) is Data Structure that keeps track of mapping between virtual end physical memory.
To Secure memory from accidental writing.*/

#ifndef _KERNEL_PAGING_H
#define _KERNEL_PAGING_H

#include <stdint.h>

// Some constants
#define PAGE_SIZE 4096 // 4 KB, 2 ^ 12 OR 2 << 11
#define PAGE_TABLE_SIZE 1024 // 1 KB, 2 ^ 10 OR 2 << 9
#define PAGE_DIRECTORY_SIZE 1024

typedef struct {
    uint32_t present : 1;
    uint32_t rw : 1;
    uint32_t user : 1;
    uint32_t reserved : 5;
    uint32_t address : 20;
} __attribute__((packed)) page_table_entry_t;

typedef struct {
    uint32_t present : 1;
    uint32_t rw : 1;
    uint32_t user : 1;
    uint32_t reserved : 5;
    uint32_t address : 20;
} __attribute__((packed)) page_directory_entry_t;

// Init functions
void paging_init_void(void);
void enable_paging(void);

#endif
