#include <stdint.h>

extern uint32_t _bss_start;
extern uint32_t _bss_end;
extern uint32_t _data_init_start;
extern uint32_t _data_start;
extern uint32_t _data_end;
extern uint32_t _stack_top;

extern void main(void);

static void _start(void) {
    // Zero out .bss section
    for (uint32_t *ptr = &_bss_start; ptr < &_bss_end; ++ptr) {
        *ptr = 0;
    }

    // Initialize .data section
    for (uint32_t *src = &_data_init_start, *dest = &_data_start; dest < &_data_end;) {
        *dest++ = *src++;
    }

    main();
}

static void *_vectors[16] __attribute__((section("zeptos_vectors"), unused)) = {
    &_stack_top,
    _start
};
