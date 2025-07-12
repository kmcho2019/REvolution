module TopModule(
    input  [3:0] x,
    output       f
);

    // 16-bit ROM storing f for each 4-bit input combination
    // Index: {x3,x2,x1,x0}
    // Values determined from the Karnaugh map:
    // x=0  0000 => f=1
    // x=1  0001 => f=0
    // x=2  0010 => f=1
    // x=3  0011 => f=0
    // x=4  0100 => f=0
    // x=5  0101 => f=0
    // x=6  0110 => f=0
    // x=7  0111 => f=0
    // x=8  1000 => f=1
    // x=9  1001 => f=1
    // x=10 1010 => f=1
    // x=11 1011 => f=0
    // x=12 1100 => f=1
    // x=13 1101 => f=1
    // x=14 1110 => f=1
    // x=15 1111 => f=1

    // Construct the ROM vector: bit 0 corresponds to x=0, bit 15 to x=15
    wire [15:0] lut = 16'b1111110110010001;

    assign f = lut[x];

endmodule