module TopModule(
    input  [3:0] x,
    output      f
);
    // Bits mapping:
    // x[0] = x1, x[1] = x2, x[2] = x3, x[3] = x4 (problem statement order)
    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    assign f = (x4 & ~x3)         // covers row 10 (x3x4) with don't cares 1's
             | (x4 & x2)          // covers cells with x4=1 and x2=1 (rows 10,11)
             | (x3 & x2)          // covers cells with x3=1 and x2=1 (row 11)
             | (~x4 & x2 & x1 & x0); // covers cell at row=00,col=11 (the '1' at 0111)

endmodule