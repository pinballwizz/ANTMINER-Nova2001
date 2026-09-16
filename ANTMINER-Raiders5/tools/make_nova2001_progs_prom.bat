copy /b 1_green.6c + 2.6d + 3.6f + 4.6g + 4.6g NJC0ROM.bin
make_vhdl_prom NJC0ROM.bin NJC0ROM.vhd

make_vhdl_prom nova2001.clr PAL_ROM.vhd

pause