module TopModule(
    input  [3:0] x,
    output       f
);

    // Input bit naming
    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Complemented signals reused
    wire nx3 = ~x3;
    wire nx1 = ~x1;
    wire nx0 = ~x0;

    // Term1: (~x3 & ~x1)
    wire term1 = nx3 & nx1;

    // Term2: (~x3 & x2 & x1 & ~x0) decomposed as ((~x3 & x2) & (x1 & ~x0))
    wire term2_and1 = nx3 & x2;
    wire term2_and2 = x1 & nx0;
    wire term2 = term2_and1 & term2_and2;

    // Term3: (x3 & x2 & (~x0 | x1))
    wire term3_and = x3 & x2;
    wire term3_or  = nx0 | x1;
    wire term3 = term3_and & term3_or;

    // Final output (sum of products)
    assign f = term1 | term2 | term3;

endmodule