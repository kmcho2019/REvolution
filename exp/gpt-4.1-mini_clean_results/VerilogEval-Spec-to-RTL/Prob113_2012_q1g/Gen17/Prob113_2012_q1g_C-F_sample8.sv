module TopModule(
    input  [3:0] x,
    output       f
);

    // Naming input bits for readability
    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Shared complemented signals
    wire nx3 = ~x3;
    wire nx1 = ~x1;
    wire nx0 = ~x0;

    // Term1: ~x3 & ~x1
    wire term1 = nx3 & nx1;

    // Term2: ~x3 & x2 & x1 & ~x0
    wire t2a = nx3 & x2;
    wire t2b = x1 & nx0;
    wire term2 = t2a & t2b;

    // Term3: x3 & x2 & (~x0 | x1)
    wire t3a = x3 & x2;
    wire t3b = nx0 | x1;
    wire term3 = t3a & t3b;

    // Final output
    assign f = term1 | term2 | term3;

endmodule