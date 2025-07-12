module TopModule (
    input  [3:0] x, // x = {x4,x3,x2,x1}
    output       f
);

    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // Based on the Karnaugh map, the minimized expression is:
    // f = x4 & x3
    //   + x4 & ~x3 & ~x2
    //   + x3 & x2 & ~x1
    //   + ~x4 & x3 & x2
    // These terms cover all 1s, assign don't-cares as zeros for simplicity.

    assign f = (x4 & x3)
             | (x4 & ~x3 & ~x2)
             | (x3 & x2 & ~x1)
             | (~x4 & x3 & x2);

endmodule