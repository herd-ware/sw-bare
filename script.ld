/*
 * File: script.ld
 * Created Date: 2023-03-31 02:52:02 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-03-31 03:57:45 pm
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */


MEMORY
{
  BOOT     (rx)  : ORIGIN = 0x00000000, LENGTH = 0x00040000
  ROM      (rx)  : ORIGIN = 0x04000000, LENGTH = 0x00040000
  RAM      (rwx) : ORIGIN = 0x08000000, LENGTH = 0x00040000
}

STACK_SIZE  = 0x3000;
BOOT_PC     = 0x1000;

/* Section Definitions */
SECTIONS
{  
  /* Boot ROM */
  .boot :
  {
    *start.o(.rodata*);
    *start.o(.srodata*);
    *init.o(.rodata*);
    *init.o(.srodata*);
    . = BOOT_PC;
    KEEP(*start.o(.text*));
    *init.o(.text*);
    . = ALIGN(16);    /* PADDING END SECTION */
  } > BOOT

  /* Code and constants */
  .text :
  {
    _stext = . ;
    *(.rodata*);
    *(.srodata*);
    *(.text*);
    _etext = . ;
    _idata = . ;
    . = ALIGN(16);    /* PADDING END SECTION */
  } > ROM

  /* Initialized data */
  .data : AT ( ADDR (.text) + SIZEOF (.text) )
  {
    . = ALIGN(8);
    _sdata = . ;
    *(.data*);
    *(.sdata*);
    _edata = . ;
    . = ALIGN(8);
    . = ALIGN(16);    /* PADDING END SECTION */
  } > RAM

  /* Unitialized data */
  .bss (NOLOAD) :
  {
    . = ALIGN(8);
    _sbss = . ;
    *(.bss*);
    *(.sbss*);
    *(COMMON);
    _ebss = . ;
    . = ALIGN(8);
  } > RAM

  /* Stack */
  .stack (NOLOAD):
  {
    . = ALIGN(8);
    . = . + STACK_SIZE;
    . = ALIGN(8);
    _stack = . ;
  } > RAM
}
