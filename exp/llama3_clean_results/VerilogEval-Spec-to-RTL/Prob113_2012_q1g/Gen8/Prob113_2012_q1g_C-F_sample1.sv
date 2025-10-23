module TopModule(
    input [3:0] x,
    output f
);

    wire x_00, x_11, x_10;
    wire f_x_00, f_x_11, f_x_10;

    assign x_00 = ~x[2] & ~x[3];
    assign x_11 = x[2] & x[3];
    assign x_10 = x[2] & ~x[3];

    assign f_x_00 = x_00 & (~x[0] & ~x[1] | x[0] & ~x[1]);
    assign f_x_11 = x_11 & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & x[1]);
    assign f_x_10 = x_10 & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & ~x[1]);

    assign f = f_x_00 | f_x_11 | f_x_10;

endmodule