module TopModule(
    input  [3:0] x,
    output       f
);

    // Input bit naming for clarity
    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Shared complemented signals to save area and power
    wire nx3 = ~x3;
    wire nx1 = ~x1;
    wire nx0 = ~x0;

    // Decompose multi-input ANDs into smaller gates for better fan-in and synthesis results

    // Term 1: (~x3 & ~x1)
    wire term1 = nx3 & nx1;

    // Term 2: (~x3 & x2 & x1 & ~x0)
    wire and_part1 = nx3 & x2;
    wire and_part2 = x1 & nx0;
    wire term2 = and_part1 & and_part2;

    // Term 3: (x3 & x2 & (~x0 | x1))
    wire and_high = x3 & x2;
    wire or_inner = nx0 | x1;
    wire term3 = and_high & or_inner;

    // Final output
    assign f = term1 | term2 | term3;

endmodule