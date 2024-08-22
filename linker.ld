/* arch/i386/linker.ld */

ENTRY(_start)
SECTIONS
{
  . = 1M;

  .text : {
    *(.multiboot)
    *(.text)
  }

  .rodata : {
    *(.rodata)
  }

  .data : {
    *(.data)
  }

  .bss : {
    *(.bss)
  }
}
