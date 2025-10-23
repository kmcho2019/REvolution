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
    // 16-bit LUT for 4-input NAND (0 when all inputs are 1, 1 otherwise)
    reg [15:0] nand_lut = 16'b1111111111111110;

    // First NAND gate using LUT
    assign p1y = nand_lut[{p1a, p1b, p1c, p1d}];
    
    // Second NAND gate using same LUT
    assign p2y = nand_lut[{p2a, p2b, p2c, p2d}];
endmodule