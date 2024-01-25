/*
 * gd32f4xx_compat.h
 *
 *  Created on: Jan 11, 2024
 *      Author: csky
 */

#ifndef INC_GD32F4XX_COMPAT_H_
#define INC_GD32F4XX_COMPAT_H_

/* bit operations */
#define REG32(addr)                  (*(volatile uint32_t *)(uint32_t)(addr))
#define REG16(addr)                  (*(volatile uint16_t *)(uint32_t)(addr))
#define REG8(addr)                   (*(volatile uint8_t *)(uint32_t)(addr))
#define USBBIT(x)                       ((uint32_t)((uint32_t)0x01U<<(x)))
#define BITS(start, end)             ((0xFFFFFFFFUL << (start)) & (0xFFFFFFFFUL >> (31U - (uint32_t)(end))))
#define GET_BITS(regval, start, end) (((regval) & BITS((start),(end))) >> (start))


#endif /* INC_GD32F4XX_COMPAT_H_ */
