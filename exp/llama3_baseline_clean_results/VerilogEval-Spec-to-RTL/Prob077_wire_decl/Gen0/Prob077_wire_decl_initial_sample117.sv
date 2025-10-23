module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire and_gate1_out;
wire and_gate2_out;

assign and_gate1_out = a & b;
assign and_gate2_out = c & d;
assign out = and_gate1_out | and_gate2_out;
assign out_n = ~out;

endmodule