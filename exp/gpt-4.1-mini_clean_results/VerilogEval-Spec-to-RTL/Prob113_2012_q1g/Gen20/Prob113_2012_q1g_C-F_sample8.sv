module TopModule(
    input  [3:0] x,
    output       f
);

    // Extract input bits
    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Shared complemented signals for reuse
    wire nx3 = ~x3;
    wire nx1 = ~x1;
    wire nx0 = ~x0;

    // Intermediate terms
    wire termA = nx1 | (x2 & nx0);  // ~x1 | (x2 & ~x0)
    wire termB = nx0 | x1;          // ~x0 | x1

    // Final function
    assign f = (nx3 & termA) | (x3 & x2 & termB);

endmodule