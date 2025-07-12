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

    // Shared 16-bit LUT for 4-input NAND truth table
    reg [15:0] nand4_lut = 16'b1111111111111110;

    // First NAND gate implementation
    wire [3:0] addr1 = {p1a, p1b, p1c, p1d};
    assign p1y = nand4_lut[addr1];

    // Second NAND gate implementation
    wire [3:0] addr2 = {p2a, p2b, p2c, p2d};
    assign p2y = nand4_lut[addr2];

endmodule