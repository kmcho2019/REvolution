module TopModule(
    input  [3:0] x,
    output       f
);

    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Partial terms from the minimal SOP expression
    wire term1 = ~x3 & ~x1;
    wire term2 = x2 & x1 & ~x0 & ~x3;
    wire term3_part = ~x0 | (x1 & x0);
    wire term3 = x3 & x2 & term3_part;

    // Combine all terms for final output
    assign f = term1 | term2 | term3;

endmodule