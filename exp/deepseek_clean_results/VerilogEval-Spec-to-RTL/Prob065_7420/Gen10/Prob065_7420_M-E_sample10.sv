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

    // LUT for first NAND gate
    reg [15:0] nand1_lut = 16'b1111111111111110;
    assign p1y = nand1_lut[{p1a, p1b, p1c, p1d}];

    // LUT for second NAND gate
    reg [15:0] nand2_lut = 16'b1111111111111110;
    assign p2y = nand2_lut[{p2a, p2b, p2c, p2d}];

endmodule