/*
 * File: init.h
 * Created Date: 2023-03-31 02:58:56 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-03-31 03:04:30 pm
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */


#ifndef INIT_H 
#define INIT_H


#include <stdint.h>
#include "isa.h"


// ******************************
//             MACRO
// ******************************

// ******************************
//        EXTERNAL VARIABLE
// ******************************
// Variables in the linker script
extern uintx_t _sbss;
extern uintx_t _ebss;
extern uintx_t _sdata;
extern uintx_t _edata;
extern uintx_t _idata;

// ******************************
//           FUNCTION
// ******************************
void bare_init();

#endif