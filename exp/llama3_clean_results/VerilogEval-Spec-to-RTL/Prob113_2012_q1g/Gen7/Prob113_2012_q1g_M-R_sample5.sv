module TopModule(
    input  [3:0] x,
    output       f
);

    wire cond_00;  // Condition when x[2] and x[3] are both 0
    wire cond_11;  // Condition when x[2] and x[3] are both 1
    wire cond_10;  // Condition when x[2] is 1 and x[3] is 0

    assign cond_00 = ~x[2] & ~x[3] & (~x[0] & ~x[1] | x[0] & ~x[1]);
    assign cond_11 = x[2] & x[3] & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & x[1]);
    assign cond_10 = x[2] & ~x[3] & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & ~x[1]);

    assign f = cond_00 | cond_11 | cond_10;

endmodule