module TopModule(
    input [3:0] x,
    output f
);

    // Conditions for x[2]x[3]
    wire x_00, x_11, x_10;
    assign x_00 = ~x[2] & ~x[3];
    assign x_11 = x[2] & x[3];
    assign x_10 = x[2] & ~x[3];

    // Conditions for x[0]x[1]
    wire x_00_condition, x_11_condition;
    assign x_00_condition = ~x[0] & ~x[1] | x[0] & ~x[1];
    assign x_11_condition = ~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & x[1];

    // Simplified expression for f
    assign f = (x_00 & x_00_condition) | (x_11 & x_11_condition) | (x_10 & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & ~x[1]));

endmodule