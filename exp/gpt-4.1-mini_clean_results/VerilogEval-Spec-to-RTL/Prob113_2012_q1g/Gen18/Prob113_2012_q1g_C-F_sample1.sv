module TopModule(
    input  [3:0] x,
    output       f
);

    // Name individual bits for clarity
    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Shared complemented signals to reduce redundant inverters
    wire nx3 = ~x3;
    wire nx1 = ~x1;
    wire nx0 = ~x0;

    // Factor and reuse the inner OR term (~x0 | x1)
    wire or_nx0_x1 = nx0 | x1;

    // Decompose complex AND terms into smaller two-input ANDs
    wire term1 = nx3 & nx1;               // ~x3 & ~x1
    wire term2a = nx3 & x2;               // ~x3 & x2
    wire term2b = x1 & nx0;               // x1 & ~x0
    wire term2  = term2a & term2b;        // ~x3 & x2 & x1 & ~x0
    wire term3a = x3 & x2;                // x3 & x2
    wire term3  = term3a & or_nx0_x1;    // x3 & x2 & (~x0 | x1)

    // Final output is the OR of all three terms
    assign f = term1 | term2 | term3;

endmodule