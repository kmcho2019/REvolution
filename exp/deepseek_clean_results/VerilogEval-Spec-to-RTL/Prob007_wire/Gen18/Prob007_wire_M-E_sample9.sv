module TopModule(input in, output out);
    // LUT implementation for wire functionality
    // Configuration: 2'b01 (pass-through)
    reg [1:0] lut = 2'b01;
    
    assign out = lut[in];
endmodule