/*
 * File: start.S
 * Created Date: 2023-03-31 02:51:10 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-03-31 03:05:54 pm
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */


//#include "asm.h"


.section .rodata

.section .text
.globl _start
_start:
  la sp, _stack

  jal bare_init
  call main  

end:
  j end