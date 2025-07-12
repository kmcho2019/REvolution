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
    // LUT for 4-input NAND (output is 0 only when all inputs are 1)
    // Index is {d,c,b,a}, value is NAND result
    reg [15:0] nand_lut = 16'b1111111111111110;

    // First NAND gate implementation
    wire [3:0] selector1 = {p1d, p1c, p1b, p1a};
    assign p1y = nand_lut[selector1];

    // Second NAND gate implementation
    wire [3:0] selector2 = {p2d, p2c, p2b, p2a};
    assign p2y = nand_lut[selector2];

endmodule