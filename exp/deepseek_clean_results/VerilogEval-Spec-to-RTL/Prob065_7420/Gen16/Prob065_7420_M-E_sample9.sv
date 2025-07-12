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

    // LUT for 4-input NAND function (output is 0 only when all inputs are 1)
    reg [15:0] nand_lut = 16'b1111_1111_1111_1110;

    // First NAND gate implementation using LUT
    wire [3:0] p1_inputs = {p1a, p1b, p1c, p1d};
    assign p1y = nand_lut[p1_inputs];

    // Second NAND gate implementation using LUT
    wire [3:0] p2_inputs = {p2a, p2b, p2c, p2d};
    assign p2y = nand_lut[p2_inputs];

endmodule