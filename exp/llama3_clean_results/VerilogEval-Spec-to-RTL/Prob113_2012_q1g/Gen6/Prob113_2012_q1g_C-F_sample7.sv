module TopModule(
    input [3:0] x,
    output f
);

    // Use intermediate signals to simplify the conditions
    wire x_00, x_11, x_10;
    assign x_00 = ~x[2] & ~x[3];
    assign x_11 = x[2] & x[3];
    assign x_10 = x[2] & ~x[3];

    // Simplify the logic expression for f using the intermediate signals
    assign f = (x_00 & (~x[0] & ~x[1] | x[0] & ~x[1])) |
               (x_11 & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & x[1])) |
               (x_10 & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & ~x[1]));

endmodule