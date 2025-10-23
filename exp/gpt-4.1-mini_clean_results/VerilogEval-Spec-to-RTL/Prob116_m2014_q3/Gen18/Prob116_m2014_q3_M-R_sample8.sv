module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1 (Gray code)
    output       f
);

    // LUT representing the function f for each input x (Gray-coded)
    // Bit position = input vector x[3:0] interpreted directly as an index
    // '1' means f=1, '0' means f=0, don't-cares set to 0
    //
    // Constructed from the K-map:
    // Row x3,x4 | Col x1,x2 | f
    // 00 00 = x[3]=0,x[2]=0 | x[1]=0,x[0]=0 -> index 4'b0000 = d->0
    // 00 01 = 0001 = 0
    // 00 10 = 0010 = d->0
    // 00 11 = 0011 = d->0
    // 01 00 = 0100 = 0
    // 01 01 = 0101 = d->0
    // 01 10 = 0110 = 1
    // 01 11 = 0111 = 0
    // 11 00 = 1100 = 1
    // 11 01 = 1101 = 1
    // 11 10 = 1110 = 0 (d->0)
    // 11 11 = 1111 = 0 (d->0)
    // 10 00 = 1000 = 1
    // 10 01 = 1001 = 1
    // 10 10 = 1010 = 0
    // 10 11 = 1011 = 0 (d->0)
    //
    // LUT (bit0 is x=0000, bit15 is x=1111): 
    // bit15  bit14  bit13  bit12  bit11  bit10  bit9  bit8  bit7  bit6  bit5  bit4  bit3  bit2  bit1  bit0
    //  0      0      1      1      0      0     1     1     0     1     0     0     0     0     0     0

    localparam [15:0] LUT = 16'b0011001101010000;

    assign f = LUT[x];

endmodule