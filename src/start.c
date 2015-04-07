#include <stdint.h>

extern uint32_t __bss_start;
extern uint32_t __bss_end;
extern uint32_t __data_init_start;
extern uint32_t __data_start;
extern uint32_t __data_end;
extern uint32_t __stack_end;

extern void main(void);

static void __start(void) {
    // Zero out .bss section
    for (uint32_t *ptr = &__bss_start; ptr < &__bss_end; ++ptr) {
        *ptr = 0;
    }

    // Initialize .data section
    for (uint32_t *src = &__data_init_start, *dest = &__data_start; dest < &__data_end;) {
        *dest++ = *src++;
    }

    main();
}

static void *__vectors[] __attribute__((section(".vectors"), unused)) = {
    &__stack_end,
    __start
};
