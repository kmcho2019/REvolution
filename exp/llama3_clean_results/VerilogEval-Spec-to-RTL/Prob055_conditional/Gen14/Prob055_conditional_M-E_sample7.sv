module PriorityEncoder(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [1:0] encoded_output
);

wire a_lt_b = (a < b);
wire a_lt_c = (a < c);
wire a_lt_d = (a < d);
wire b_lt_c = (b < c);
wire b_lt_d = (b < d);
wire c_lt_d = (c < d);

assign encoded_output[0] = (a_lt_b && a_lt_c && a_lt_d) ? 1'b0 :
                           (b_lt_a && b_lt_c && b_lt_d) ? 1'b1 :
                           (c_lt_a && c_lt_b && c_lt_d) ? 1'b0 :
                           1'b1;

assign encoded_output[1] = (a_lt_b && a_lt_c) ? 1'b0 :
                           (a_lt_b && a_lt_d) ? 1'b0 :
                           (b_lt_c && b_lt_d) ? 1'b1 :
                           (c_lt_d) ? 1'b0 :
                           1'b1;

endmodule

module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

wire [1:0] encoded_output;

PriorityEncoder priority_encoder(
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .encoded_output(encoded_output)
);

assign min = (encoded_output == 2'b00) ? a :
             (encoded_output == 2'b01) ? b :
             (encoded_output == 2'b10) ? c :
             d;

endmodule