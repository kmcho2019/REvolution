module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1 (Gray-coded)
    output       f
);

    // For clarity, name bits (from MSB to LSB)
    wire x4 = x[3];
    wire x3 = x[2];
    wire x2 = x[1];
    wire x1 = x[0];

    // From the Karnaugh map, where x3x4 and x1x2 are Gray-coded indices.

    // f=1 for these Gray-coded input combinations (x4 x3 x2 x1):
    // From the table (rows = x3x4, cols = x1x2):
    // row x3x4 = 11 (x4=1,x3=1), col x1x2 = 00(0,0) => (x4=1,x3=1,x2=0,x1=0) f=1
    // row=11, col=01(0,1) => (1,1,0,1) f=1
    // row=10, col=00(1,0,0,0) f=1
    // row=10, col=01(1,0,0,1) f=1
    // row=01, col=11(0,1,1,1) f=1

    // So f=1 for inputs:
    // (x4,x3,x2,x1) = 1 1 0 0
    //                1 1 0 1
    //                1 0 0 0
    //                1 0 0 1
    //                0 1 1 1

    // Write minterms corresponding to these bit patterns:

    wire m0 = x4 &  x3 & ~x2 & ~x1;  // 1100
    wire m1 = x4 &  x3 & ~x2 &  x1;  // 1101
    wire m2 = x4 & ~x3 & ~x2 & ~x1;  // 1000
    wire m3 = x4 & ~x3 & ~x2 &  x1;  // 1001
    wire m4 = ~x4 & x3 &  x2 &  x1;  // 0111

    assign f = m0 | m1 | m2 | m3 | m4;

endmodule