module TopModule(
    input [3:0] x,
    output f
);

    // Intermediate signals for conditions related to x[2] and x[3]
    wire x_00, x_11, x_10;

    // Conditions for x[2]x[3]
    assign x_00 = ~x[2] & ~x[3];
    assign x_11 = x[2] & x[3];
    assign x_10 = x[2] & ~x[3];

    // Simplify logic based on x[0] and x[1]
    wire x_01, x_10_0;

    assign x_01 = ~x[0] & x[1];
    assign x_10_0 = x[0] & ~x[1];

    // Combine conditions to determine output f
    assign f = (x_00 & (~x[0] & ~x[1] | x_10_0)) |
               (x_11 & (~x[0] & ~x[1] | x_01 | x_10_0)) |
               (x_10 & (~x[0] & ~x[1] | x_01 | x_10_0));

endmodule