module TopModule(
    input  [3:0] x,
    output       f
);

    // Input bit naming for clarity
    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Shared complemented signals to save power and area
    wire nx3 = ~x3;
    wire nx1 = ~x1;
    wire nx0 = ~x0;

    // Term1: ~x3 & ~x1
    wire term1 = nx3 & nx1;

    // Term2: ~x3 & x2 & x1 & ~x0, decomposed into two smaller ANDs
    wire term2_part1 = nx3 & x2;
    wire term2_part2 = x1 & nx0;
    wire term2 = term2_part1 & term2_part2;

    // Term3: x3 & x2 & (~x0 | x1)
    wire and_high = x3 & x2;
    wire or_inner = nx0 | x1;
    wire term3 = and_high & or_inner;

    // Final output is the OR of the three terms
    assign f = term1 | term2 | term3;

endmodule