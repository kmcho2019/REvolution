module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire count_a, count_b, count_c, count_d;
assign count_a = a;
assign count_b = b;
assign count_c = c;
assign count_d = d;

wire [3:0] count;
assign count = {count_a, count_b, count_c, count_d};

assign q = (count >= 2'b10) ? 1'b1 : 1'b0;

endmodule