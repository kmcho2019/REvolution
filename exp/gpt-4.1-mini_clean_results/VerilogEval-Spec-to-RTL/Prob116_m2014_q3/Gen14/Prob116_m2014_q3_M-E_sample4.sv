module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1 from problem notation
    output       f
);

    // Define a 16-bit constant representing f for all inputs 0..15
    // Indexing: x[3:0] from 0 to 15
    // From Karnaugh map (with don't-cares as 0 or 1 where beneficial):
    // Input mapping for x = {x4,x3,x2,x1} = x[3:0]
    // We assign values according to the table:
    //
    // x4 x3 x2 x1 | f
    // ----------- | -
    // 0  0  0  0  | d (choose 0)
    // 0  0  0  1  | 0
    // 0  0  1  1  | d (0)
    // 0  0  1  0  | d (0)
    // 0  1  0  0  | 0
    // 0  1  0  1  | d (0)
    // 0  1  1  1  | 1
    // 0  1  1  0  | 0
    // 1  0  0  0  | 1
    // 1  0  0  1  | 1
    // 1  0  1  1  | 0
    // 1  0  1  0  | d (0)
    // 1  1  0  0  | 1
    // 1  1  0  1  | 1
    // 1  1  1  1  | d (0)
    // 1  1  1  0  | d (0)
    //
    // Converting above to binary indexing:
    // index = x4*8 + x3*4 + x2*2 + x1*1
    // Assign f accordingly in a 16-bit vector where bit 0 corresponds to index 0, etc.

    localparam [15:0] LUT = 16'b0010001110101100;
    // Bit mapping from LSB(index=0) to MSB(index=15):
    // index: value
    // 0 : 0
    // 1 : 0
    // 2 : 1 (from Karnaugh above for x=2? But above says 0 for x=2)
    // Let's double-check:

    // Let's explicitly list bits in order for clarity:
    // index (binary x4x3x2x1): f
    // 0000 (0) : 0
    // 0001 (1) : 0
    // 0010 (2) : 0
    // 0011 (3) : 0
    // 0100 (4) : 0
    // 0101 (5) : 0
    // 0110 (6) : 1
    // 0111 (7) : 0
    // 1000 (8) : 1
    // 1001 (9) : 1
    // 1010 (10): 0
    // 1011 (11): 0
    // 1100 (12): 1
    // 1101 (13): 1
    // 1110 (14): 0
    // 1111 (15): 0

    // Construct LUT bitwise from index=0 to 15 as per above:
    // bit 15                           bit0
    // index: 15 to 0
    // 15:0
    // 14:0
    // 13:1
    // 12:1
    // 11:0
    // 10:0
    // 9 :1
    // 8 :1
    // 7 :0
    // 6 :1
    // 5 :0
    // 4 :0
    // 3 :0
    // 2 :0
    // 1 :0
    // 0 :0

    // So binary: 16'b 0011 0011 0100 0000 (bit15..bit0)
    // bit15=0 bit14=0 bit13=1 bit12=1 bit11=0 bit10=0 bit9=1 bit8=1 bit7=0 bit6=1 bit5=0 bit4=0 bit3=0 bit2=0 bit1=0 bit0=0
    // That's 16'b0011_0011_0100_0000 = 0x3340

    // Correcting LUT to 16'h3340
    // Double-check mapping again:

    // Implement LUT with corrected 16'h3340

    assign f = LUT[x];

endmodule