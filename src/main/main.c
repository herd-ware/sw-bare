/*
 * File: main.c
 * Created Date: 2023-03-31 02:58:56 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-04-17 02:47:56 pm
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */


#include "main.h"


uint32_t aaa = 0xaabbccdd;

void main() {  
  gpio_set_bit(GPIOA, 10);
  uart_config(UART0, 1, 1, 1, 1, 0, UART_BAUD_230400);

  uart_send_array(UART0, "\nStart bare-metal software ...\n", 31);
  uart_send_array(UART0, "[OK] Initialization.\n", 21);

  char sconv[30];
  uint8_t ssize;

  ssize = sprintf(sconv, "[OK] Value: %u\n", 18);
  uart_send_array(UART0, sconv, ssize);

  while(!uart_status_idle(UART0));

  //wait_cycle(5000);
}