module TopModule(
    input  [3:0] x,
    output       f
);

    // Input bits for clarity
    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Shared complemented signals to reduce redundant inverters
    wire nx3 = ~x3;
    wire nx1 = ~x1;
    wire nx0 = ~x0;

    // Term 1: (~x3 & ~x1)
    wire term1 = nx3 & nx1;

    // Term 2: (~x3 & x2 & x1 & ~x0)
    wire term2_and1 = nx3 & x2;
    wire term2_and2 = x1 & nx0;
    wire term2 = term2_and1 & term2_and2;

    // Term 3: (x3 & x2 & (~x0 | x1))
    wire term3_and = x3 & x2;
    wire term3_or = nx0 | x1;
    wire term3 = term3_and & term3_or;

    // Final output
    assign f = term1 | term2 | term3;

endmodule