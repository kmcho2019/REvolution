module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output       f
);
    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // From the Karnaugh map analysis (with don't-cares assigned to simplify):
    // f = (x4 & x3) | (x4 & ~x3 & ~x2) | (x4 & ~x3 & x2 & x1) | (~x4 & x3 & x2)

    assign f = (x4 & x3) | (x4 & ~x3 & ~x2) | (x4 & ~x3 & x2 & x1) | (~x4 & x3 & x2);

endmodule