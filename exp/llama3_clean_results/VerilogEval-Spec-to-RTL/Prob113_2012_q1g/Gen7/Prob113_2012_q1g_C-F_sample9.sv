module TopModule(
    input [3:0] x,
    output f
);

    // Intermediate signals for conditions related to x[2] and x[3]
    wire x_00 = ~x[2] & ~x[3];
    wire x_11 = x[2] & x[3];
    wire x_10 = x[2] & ~x[3];

    // Simplify the logic for f using the intermediate signals
    assign f = (x_00 & (~x[0] & ~x[1] | x[0] & ~x[1])) |
               (x_11 & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & x[1])) |
               (x_10 & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & ~x[1]));

endmodule