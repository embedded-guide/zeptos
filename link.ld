__stack_size = 1024;

MEMORY {
    flash(rx) : org = 0x08000000, len = 512k
    sram(rwx) : org = 0x20000000, len = 128k
}

SECTIONS {
    .text : {
        KEEP(*(.vectors));
        *(.text);
        *(.rodata .rodata.*);
    } >flash

    .data : {
        __data_init_start = LOADADDR(.data);
        __data_start = .;
        *(.data .data.*);
        __data_end = .;
    } >sram AT >flash

    .bss : {
        __bss_start = .;
        *(.bss .bss.*);
        __bss_end = .;
    } >sram

    .stack (NOLOAD) : ALIGN(4) {
        __stack_top = .;
        . += __stack_size;
        __stack_end = .;
    } >sram
}
