module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire and_out_1;
wire or_in_2;

assign and_out_1 = a & b;
assign or_in_2 = c & d;

assign out = and_out_1 | or_in_2;
assign out_n = ~out;

endmodule