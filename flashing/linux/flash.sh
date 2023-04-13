#! /bin/bash

./openocd -f ftdi_ti60.cfg -f debug_ti.cfg -c "load_image zephyr.bin 0xF9000000" -c "reg pc 0xF9000000" -c "resume"
