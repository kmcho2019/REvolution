module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire and1_result;
wire and2_result;

assign and1_result = a & b;
assign and2_result = c & d;

assign out = and1_result | and2_result;
assign out_n = ~out;

endmodule