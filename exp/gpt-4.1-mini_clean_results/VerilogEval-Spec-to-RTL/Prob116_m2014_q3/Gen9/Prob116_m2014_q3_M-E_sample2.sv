module TopModule (
    input  [3:0] x,
    output       f
);

    // ROM content derived from K-map (row: x[3]x[2], col: x[1]x[0]):
    // Using the problem's notation, but indexing columns with x[1]x[0] 
    // to fully represent 4 input bits (assuming x[0] is the least significant)
    // Assign don't-cares to 0.
    // K-map entries per (row,column):
    // row\col 00 01 11 10
    // 00      d  0  d  d
    // 01      0  d  1  0
    // 11      1  1  d  d
    // 10      1  1  0  d
    //
    // Flattened as per input bits: x[3]x[2]x[1]x[0]
    // Index = x[3]*8 + x[2]*4 + x[1]*2 + x[0]
    // The 16-bit constant's bit n corresponds to input n

    localparam [15:0] LUT = 16'b
        // bit 15: x=1111 row=11 col=11 d (assign 0)
        // bit 14: x=1110 row=11 col=10 d (assign 0)
        // bit 13: x=1101 row=11 col=01 1
        // bit 12: x=1100 row=11 col=00 1
        // bit 11: x=1011 row=10 col=11 0
        // bit 10: x=1010 row=10 col=10 d (assign 0)
        // bit 9 : x=1001 row=10 col=01 1
        // bit 8 : x=1000 row=10 col=00 1
        // bit 7 : x=0111 row=01 col=11 1
        // bit 6 : x=0110 row=01 col=10 0
        // bit 5 : x=0101 row=01 col=01 d (assign 0)
        // bit 4 : x=0100 row=01 col=00 0
        // bit 3 : x=0011 row=00 col=11 d (assign 0)
        // bit 2 : x=0010 row=00 col=10 d (assign 0)
        // bit 1 : x=0001 row=00 col=01 0
        // bit 0 : x=0000 row=00 col=00 d (assign 0)
        16'b0000100111000110;

    assign f = LUT[x];

endmodule