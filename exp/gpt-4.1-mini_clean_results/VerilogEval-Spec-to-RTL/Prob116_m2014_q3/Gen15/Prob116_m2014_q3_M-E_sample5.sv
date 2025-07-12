module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1 (Gray code)
    output        f
);

    // Karnaugh map organized as a 16-bit constant.
    // Index is directly 'x' in Gray code order for row = x[3:2], col = x[1:0].
    // Bit positions: [15:0], where bit 0 corresponds to x=4'b0000.
    //
    // Given K-map:
    //                x[1]x[2]
    //  x[3]x[4]   00  01  11  10
    //        00 | d | 0 | d | d |
    //        01 | 0 | d | 1 | 0 |
    //        11 | 1 | 1 | d | d |
    //        10 | 1 | 1 | 0 | d |
    //
    // Let's write this as a truth table where each input 'x' is row concatenated with column (both Gray code):
    // Map inputs (x3,x4,x1,x2) = (x[3], x[2], x[0], x[1])
    // For clarity, enumerate all 16 input values and assign outputs (d=0):

    // x  b15..b0 (x descending)
    // x=0000 (0) => row=00 col=00 => d->0
    // x=0001 (1) => row=00 col=01 => 0
    // x=0010 (2) => row=00 col=10 => d->0
    // x=0011 (3) => row=00 col=11 => d->0

    // x=0100 (4) => row=01 col=00 => 0
    // x=0101 (5) => row=01 col=01 => d->0
    // x=0110 (6) => row=01 col=10 => 1
    // x=0111 (7) => row=01 col=11 => 0

    // x=1000 (8) => row=10 col=00 => 1
    // x=1001 (9) => row=10 col=01 => 1
    // x=1010 (10) => row=10 col=10 => 0
    // x=1011 (11) => row=10 col=11 => d->0

    // x=1100 (12) => row=11 col=00 => 1
    // x=1101 (13) => row=11 col=01 => 1
    // x=1110 (14) => row=11 col=10 => d->0
    // x=1111 (15) => row=11 col=11 => d->0

    // Build a 16-bit vector where bit n corresponds to x=n, LSB = x=0

    localparam [15:0] LUT = 16'b0000_1000_1100_1110;

    // Let's check bits set in above binary constant:
    // bit0 = x=0 = 0
    // bit1 = x=1 = 0
    // bit2 = x=2 = 0
    // bit3 = x=3 = 0
    // bit4 = x=4 = 0
    // bit5 = x=5 = 0
    // bit6 = x=6 = 1
    // bit7 = x=7 = 0
    // bit8 = x=8 = 1
    // bit9 = x=9 = 1
    // bit10= x=10= 0
    // bit11= x=11= 0
    // bit12= x=12= 1
    // bit13= x=13= 1
    // bit14= x=14= 0
    // bit15= x=15= 0

    assign f = LUT[x];

endmodule