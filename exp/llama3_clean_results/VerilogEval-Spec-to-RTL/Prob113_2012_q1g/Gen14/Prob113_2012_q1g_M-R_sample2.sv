module TopModule(
    input  [3:0] x,
    output       f
);

    wire f_00, f_01, f_11, f_10;
    wire f_x2_x3_00, f_x2_x3_01, f_x2_x3_11, f_x2_x3_10;

    assign f_x2_x3_00 = ~x[2] & ~x[3];
    assign f_x2_x3_01 = ~x[2] & x[3];
    assign f_x2_x3_11 = x[2] & x[3];
    assign f_x2_x3_10 = x[2] & ~x[3];

    assign f_00 = ~x[0] & ~x[1];
    assign f_01 = ~x[0] & x[1];
    assign f_11 = x[0] & x[1];
    assign f_10 = x[0] & ~x[1];

    assign f = (f_x2_x3_00 & (f_00 | f_10)) |
               (f_x2_x3_11 & (f_00 | f_01 | f_11)) |
               (f_x2_x3_10 & (f_00 | f_01 | f_10));

endmodule