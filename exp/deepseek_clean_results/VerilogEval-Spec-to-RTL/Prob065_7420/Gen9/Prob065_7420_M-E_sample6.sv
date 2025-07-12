module TopModule (
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output p1y,
    output p2y
);

    // LUT-based 4-input NAND implementation
    // The LUT contains the output for all 16 possible input combinations
    // Index is {d,c,b,a}, output is NAND of all inputs
    reg [15:0] nand4_lut = 16'b1111111111111110;
    
    // First NAND gate using LUT
    assign p1y = nand4_lut[{p1d, p1c, p1b, p1a}];
    
    // Second NAND gate using same LUT
    assign p2y = nand4_lut[{p2d, p2c, p2b, p2a}];

endmodule