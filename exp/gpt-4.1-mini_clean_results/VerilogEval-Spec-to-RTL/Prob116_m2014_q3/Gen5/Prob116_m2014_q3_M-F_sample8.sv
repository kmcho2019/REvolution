module TopModule(
    input  [3:0] x,
    output      f
);

    // According to problem:
    // Karnaugh map rows = x[3] x[4], but x[4] doesn't exist.
    // So interpret row as x[3] x[0]
    // Columns = x[1] x[2]
    // Therefore, LUT index = {x[3], x[0], x[1], x[2]} (MSB to LSB)

    // Karnaugh map (row x col):
    // x[3]x[0]\x[1]x[2]  00  01  11  10
    //       00         d   0   d   d
    //       01         0   d   1   0
    //       11         1   1   d   d
    //       10         1   1   0   d

    // Let's list LUT bits (index = {x3,x0,x1,x2}):
    // Index (bin)  : (row,col)   f
    // 0000 (0)     : 00,00       d -> 0
    // 0001 (1)     : 00,01       0
    // 0010 (2)     : 00,11       d -> 0
    // 0011 (3)     : 00,10       d -> 0

    // 0100 (4)     : 01,00       0
    // 0101 (5)     : 01,01       d -> 0
    // 0110 (6)     : 01,11       1
    // 0111 (7)     : 01,10       0

    // 1000 (8)     : 11,00       1
    // 1001 (9)     : 11,01       1
    // 1010 (10)    : 11,11       d -> 0
    // 1011 (11)    : 11,10       d -> 0

    // 1100 (12)    : 10,00       1
    // 1101 (13)    : 10,01       1
    // 1110 (14)    : 10,11       0
    // 1111 (15)    : 10,10       d -> 0

    // Filling bits accordingly (MSB = index 15, LSB = index 0):
    // Bits: 15..0 = 0 0 0 0 1 1 0 0 0 0 1 0 0 0 0 0 (tentative, verify carefully)

    // Let's write bits explicitly:
    // index : bit
    //  0:0
    //  1:0
    //  2:0
    //  3:0
    //  4:0
    //  5:0
    //  6:1
    //  7:0
    //  8:1
    //  9:1
    // 10:0
    // 11:0
    // 12:1
    // 13:1
    // 14:0
    // 15:0

    // Thus binary:  15..0 = 00_0110_0110_0010_0000 (grouped by 4 bits)
    // Let's map bits in order: bit[15]=index15=0, bit[14]=index14=0, bit[13]=1, bit[12]=1, bit[11]=0, bit[10]=0,
    // bit[9]=1, bit[8]=1, bit[7]=0, bit[6]=1, bit[5]=0, bit[4]=0, bit[3]=0, bit[2]=0, bit[1]=0, bit[0]=0

    // Wait this conflicts with previous array, let's list bits precisely:

    // index:bit (from above)
    //  0:0
    //  1:0
    //  2:0
    //  3:0
    //  4:0
    //  5:0
    //  6:1
    //  7:0
    //  8:1
    //  9:1
    // 10:0
    // 11:0
    // 12:1
    // 13:1
    // 14:0
    // 15:0

    // Let's write from bit 15 down to bit 0:
    // bit15 = index15 = 0
    // bit14 = index14 = 0
    // bit13 = index13 = 1
    // bit12 = index12 = 1
    // bit11 = index11 = 0
    // bit10 = index10 = 0
    // bit9  = index9  = 1
    // bit8  = index8  = 1
    // bit7  = index7  = 0
    // bit6  = index6  = 1
    // bit5  = index5  = 0
    // bit4  = index4  = 0
    // bit3  = index3  = 0
    // bit2  = index2  = 0
    // bit1  = index1  = 0
    // bit0  = index0  = 0

    // Binary: 00_11_00_11_01_00_00_00 = 16'b0011_0011_0100_0000 = 16'h3340

    localparam [15:0] LUT = 16'h3340;

    wire [3:0] lut_idx = {x[3], x[0], x[1], x[2]};

    assign f = LUT[lut_idx];

endmodule