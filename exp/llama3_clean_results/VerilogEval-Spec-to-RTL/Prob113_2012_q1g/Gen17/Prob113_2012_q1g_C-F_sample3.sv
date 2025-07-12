module TopModule(
    input  [3:0] x,
    output       f
);

    wire cond_00, cond_01, cond_10, cond_11;
    wire x2_x3_00, x2_x3_01, x2_x3_11, x2_x3_10;

    assign x2_x3_00 = ~x[2] & ~x[3];
    assign x2_x3_01 = ~x[2] & x[3];
    assign x2_x3_11 = x[2] & x[3];
    assign x2_x3_10 = x[2] & ~x[3];

    assign cond_00 = ~x[0] & ~x[1];
    assign cond_01 = ~x[0] & x[1];
    assign cond_10 = x[0] & ~x[1];
    assign cond_11 = x[0] & x[1];

    assign f = (x2_x3_00 & (cond_00 | cond_10)) |
               (x2_x3_11 & (cond_00 | cond_01 | cond_11)) |
               (x2_x3_10 & (cond_00 | cond_01 | cond_10));

endmodule