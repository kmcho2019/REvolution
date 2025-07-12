module TopModule(
    input  [3:0] x,
    output      f
);
    // Assign input bits to variables for clarity:
    // x[3]: MSB, x[0]: LSB
    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // From the Karnaugh map, ones at:
    // Row x3x0 / Column x1x2
    // (0,11) = x3=0,x0=0,x1=1,x2=1 -> 4'b0 1 1 0: x=4'b0110
    // (1,00) = x3=0,x0=1,x1=0,x2=0 -> 4'b0 0 0 1: x=4'b0011
    // (1,01) = x3=0,x0=1,x1=0,x2=1 -> 4'b0 1 0 1: x=4'b0111
    // (2,00) = x3=1,x0=1,x1=0,x2=0 -> 4'b1 0 0 1: x=4'b1001
    // (2,01) = x3=1,x0=1,x1=0,x2=1 -> 4'b1 1 0 1: x=4'b1101
    // (3,00) = x3=1,x0=0,x1=0,x2=0 -> 4'b1 0 0 0: x=4'b1000
    // (3,01) = x3=1,x0=0,x1=0,x2=1 -> 4'b1 1 0 0: x=4'b1100

    // Simplify by inspection:
    // Group 1: x3=1, x1=0 (covers entries at rows 2 and 3, columns 00 and 01)
    // Group 2: x0=1, x1=0, x2=1 (covers entries 1,01 and 2,01)
    // Group 3: x3=0,x0=0,x1=1,x2=1 (entry 0,11)

    assign f = (x3 & ~x1)          // group 1
             | (x0 & ~x1 & x2)    // group 2
             | (~x3 & ~x0 & x1 & x2); // group 3

endmodule