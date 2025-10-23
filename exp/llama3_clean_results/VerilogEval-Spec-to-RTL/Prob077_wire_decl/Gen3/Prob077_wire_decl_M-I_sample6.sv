module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire and_result1, and_result2;

assign and_result1 = a & b;
assign and_result2 = c & d;
assign out = and_result1 | and_result2;
assign out_n = ~out;

endmodule