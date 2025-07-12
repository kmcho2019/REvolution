module TopModule(
    input [3:0] x,
    output f
);
    // Row = {x[3], x[0]} (2 bits)
    // Col = {x[1], x[2]} (2 bits)
    wire [3:0] addr = {x[3], x[0], x[1], x[2]};
    // Map from Karnaugh map (row*4 + col):
    // row\col  00   01   11   10
    // 00       d=0  0    d=0  d=0
    // 01       0    d=0   1    0
    // 11       1    1    d=0  d=0
    // 10       1    1    0    d=0

    // Address values and f output:
    // 0: row=00(0) col=00(0) -> 0 (d=0)
    // 1: row=00 col=01 -> 0
    // 2: row=00 col=11 -> 0 (d=0)
    // 3: row=00 col=10 -> 0 (d=0)
    // 4: row=01 col=00 -> 0
    // 5: row=01 col=01 -> 0 (d=0)
    // 6: row=01 col=11 -> 1
    // 7: row=01 col=10 -> 0
    // 8: row=11 col=00 -> 1
    // 9: row=11 col=01 -> 1
    // 10: row=11 col=11 -> 0 (d=0)
    // 11: row=11 col=10 -> 0 (d=0)
    // 12: row=10 col=00 -> 1
    // 13: row=10 col=01 -> 1
    // 14: row=10 col=11 -> 0 (d=0)
    // 15: row=10 col=10 -> 0 (d=0)

    // So LUT = bit[15:0] indexed by addr:
    // addr : f
    //  0 :0
    //  1 :0
    //  2 :0
    //  3 :0
    //  4 :0
    //  5 :0
    //  6 :1
    //  7 :0
    //  8 :1
    //  9 :1
    // 10 :0
    // 11 :0
    // 12 :1
    // 13 :1
    // 14 :0
    // 15 :0

    wire [15:0] lut = 16'b0000110011000110; // bit0=addr0 = f0, bit15=addr15=f15

    assign f = lut[addr];

endmodule