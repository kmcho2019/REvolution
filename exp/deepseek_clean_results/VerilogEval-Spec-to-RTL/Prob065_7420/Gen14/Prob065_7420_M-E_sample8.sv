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
    function automatic logic nand4_lut(input a, b, c, d);
        logic [15:0] lut = 16'b1111111111111110; // All combinations except 1111
        logic [3:0] index = {a, b, c, d};
        return lut[index];
    endfunction

    // First NAND gate using LUT
    assign p1y = nand4_lut(p1a, p1b, p1c, p1d);

    // Second NAND gate using LUT
    assign p2y = nand4_lut(p2a, p2b, p2c, p2d);

endmodule