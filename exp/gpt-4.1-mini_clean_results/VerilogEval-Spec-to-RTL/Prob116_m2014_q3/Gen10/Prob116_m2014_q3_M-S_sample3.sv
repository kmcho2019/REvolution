module TopModule(
    input  [3:0] x, // x = {x4,x3,x2,x1} = {x[3],x[2],x[1],x[0]}
    output      f
);

    // Truth table for f indexed by {x4 x3 x2 x1}:
    // From the Karnaugh map (rows=x3x4, cols=x1x2), mapped to 4-bit inputs:
    // The bits are ordered so that bit 0 corresponds to x=0000, bit 15 to x=1111.
    // We set don't-cares to '0' or '1' to minimize complexity.

    // Index: x4 x3 x2 x1 (MSB to LSB)
    // From the Karnaugh map:
    // x4x3\x2x1  00  01  11  10
    //  00       d    0   d   d
    //  01       0    d   1   0
    //  11       1    1   d   d
    //  10       1    1   0   d

    // Let's write the 16-bit vector from x=0000 (LSB) to x=1111 (MSB):
    // x4x3x2x1 : f
    // 0000 (0): d -> choose 0
    // 0001 (1): 0
    // 0010 (2): d -> choose 0
    // 0011 (3): d -> choose 0
    // 0100 (4): 0
    // 0101 (5): d -> choose 0
    // 0110 (6): 1
    // 0111 (7): 0
    // 1000 (8): 1
    // 1001 (9): 1
    // 1010 (10): 0
    // 1011 (11): d -> choose 0
    // 1100 (12): 1
    // 1101 (13): 1
    // 1110 (14): d -> choose 0
    // 1111 (15): d -> choose 0

    // Binary: bit15 ... bit0 = f(1111) ... f(0000)
    // bit15:0,14:0,13:1,12:1,11:0,10:0,9:1,8:1,7:0,6:1,5:0,4:0,3:0,2:0,1:0,0:0
    // So: 0b0011001101000000 = 0x3340

    localparam [15:0] LUT = 16'h3340;

    assign f = LUT[x];

endmodule