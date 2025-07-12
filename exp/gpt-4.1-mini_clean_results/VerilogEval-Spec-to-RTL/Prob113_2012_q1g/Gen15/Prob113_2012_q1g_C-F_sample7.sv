module TopModule(
    input  [3:0] x,
    output       f
);

    // Extract individual bits for clarity
    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Intermediate terms from minimal factored SOP expression

    // Term1: ~x3 & ~x1
    wire term1 = ~x3 & ~x1;

    // Term2: x2 & x1 & ~x0 & ~x3
    wire term2 = x2 & x1 & ~x0 & ~x3;

    // Term3 part A: ~x0
    wire term3a = ~x0;

    // Term3 part B: x1 & x0
    wire term3b = x1 & x0;

    // Term3 combined: (term3a | term3b)
    wire term3_part = term3a | term3b;

    // Term3: x3 & x2 & term3_part
    wire term3 = x3 & x2 & term3_part;

    // Final output is OR of all terms
    assign f = term1 | term2 | term3;

endmodule