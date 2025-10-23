module TopModule(
    input  [3:0] x,
    output       f
);

    wire [1:0] encoded_x2_x3;
    wire f_encoded_00, f_encoded_01, f_encoded_11, f_encoded_10;

    // Priority Encoder for x[2] and x[3]
    assign encoded_x2_x3[0] = ~x[2] & ~x[3];
    assign encoded_x2_x3[1] = x[2] & ~x[3];

    // AND-OR Gates for output f
    assign f_encoded_00 = encoded_x2_x3[0] & (~x[0] & ~x[1]);
    assign f_encoded_01 = encoded_x2_x3[0] & (~x[0] & x[1]);
    assign f_encoded_11 = encoded_x2_x3[1] & (x[0] & x[1]);
    assign f_encoded_10 = encoded_x2_x3[1] & (x[0] & ~x[1]);

    assign f = (encoded_x2_x3[0] & (f_encoded_00 | f_encoded_10)) |
               (encoded_x2_x3[1] & (f_encoded_00 | f_encoded_01 | f_encoded_11));

endmodule