_stack_size = 1024;

MEMORY {
    flash(rx) : org = 0x08000000, len = 512k
    sram(rwx) : org = 0x20000000, len = 128k
}

SECTIONS {
    .text : {
        KEEP(*(vector_table));
        *(.text .text.*);
        *(.rodata .rodata.*);
    } > flash

    .data : {
        _data_init_start = LOADADDR(.data);
        _data_start = .;
        *(.data .data.*);
        _data_end = .;
    } > sram AT > flash

    .bss : {
        _bss_start = .;
        _stack_bottom = .;
        . += _stack_size;
        _stack_top = .;
        *(.bss .bss.*);
        _bss_end = .;
    } > sram
}
