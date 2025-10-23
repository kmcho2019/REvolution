module TopModule(
    input  [3:0] x,
    output       f
);

    wire cond_00, cond_11, cond_10;

    assign cond_00 = (~x[2] & ~x[3]) & (~x[0] & ~x[1] | x[0] & ~x[1]);
    assign cond_11 = (x[2] & x[3]) & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & x[1]);
    assign cond_10 = (x[2] & ~x[3]) & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & ~x[1]);

    assign f = cond_00 | cond_11 | cond_10;

endmodule