module TopModule(
    input  [3:0] x,
    output       f
);

    wire x02, x12, x03;
    wire f_x02, f_x12, f_x03;

    assign x02 = ~x[2] & ~x[3];
    assign x12 = x[2] & x[3];
    assign x03 = x[2] & ~x[3];

    assign f_x02 = x02 & (~x[0] & ~x[1] | x[0] & ~x[1]);
    assign f_x12 = x12 & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & x[1]);
    assign f_x03 = x03 & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & ~x[1]);

    assign f = f_x02 | f_x12 | f_x03;

endmodule