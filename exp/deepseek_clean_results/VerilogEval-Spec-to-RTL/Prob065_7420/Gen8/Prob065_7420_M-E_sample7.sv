module TopModule (
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output reg p1y,
    output reg p2y
);

    // Truth table for 4-input NAND (16 entries)
    // Index is {d,c,b,a}, output is NAND of these bits
    wire [15:0] nand_lut = 16'b1111111111111110;

    // First NAND gate implementation
    always @(*) begin
        p1y = nand_lut[{p1d, p1c, p1b, p1a}];
    end

    // Second NAND gate implementation
    always @(*) begin
        p2y = nand_lut[{p2d, p2c, p2b, p2a}];
    end

endmodule