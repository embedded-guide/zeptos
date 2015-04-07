#include <stdint.h>

// Registers we'll be using in our minimal example
static volatile uint32_t *RCC_AHB1ENR = (uint32_t *) 0x40023830;
static volatile uint32_t *GPIOA_MODER = (uint32_t *) 0x40020000;
static volatile uint32_t *GPIOA_ODR = (uint32_t *) 0x40020014;

void main(void) {
    // Enable the GPIO Port A peripheral
    *RCC_AHB1ENR = 1;

    // Put pin PA5 in output mode
    *GPIOA_MODER |= 1 << 10;

    for (;;) {
        // Toggle pin PA5
        *GPIOA_ODR ^= 1 << 5;

        // Spend some time doing nothing
        for (int i = 1000000; i; --i);
    }
}
