/*
 * File: init.c
 * Created Date: 2023-03-31 02:58:56 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-03-31 04:58:10 pm
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */


#include "init.h"


void bare_init() {
  // Initialize to zero BSS section
  for (uint32_t *p_bss = &_sbss; p_bss < &_ebss; p_bss = p_bss + 1) {
    *p_bss = 0;
  }

  // Copy init values from ROM to RAM
  for (uint32_t offset = 0; offset < (&_edata - &_sdata); offset = offset + 1) {
    *(&_sdata + offset) = *(&_idata + offset);
  }  
}