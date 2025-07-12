module TopModule(
    input  [3:0] x,
    output       f
);

    wire f_x2_x3_00, f_x2_x3_01, f_x2_x3_11, f_x2_x3_10;
    wire x0_equals_x1;

    assign f_x2_x3_00 = ~x[2] & ~x[3];
    assign f_x2_x3_11 = x[2] & x[3];
    assign f_x2_x3_10 = x[2] & ~x[3];

    assign x0_equals_x1 = (x[0] == x[1]);

    assign f = (f_x2_x3_11 & (x[0] | x[1])) |
               (f_x2_x3_00 & x0_equals_x1) |
               (f_x2_x3_10 & x0_equals_x1);

endmodule