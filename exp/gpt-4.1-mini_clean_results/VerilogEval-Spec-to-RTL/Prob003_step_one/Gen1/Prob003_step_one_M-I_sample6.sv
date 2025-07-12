module TopModule(output one);
    // Instantiate a built-in VCC cell to tie output to power directly
    VCC vcc_inst(.Y(one));
endmodule