module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire and1_out, and2_out;

assign and1_out = a & b;
assign and2_out = c & d;

assign out = and1_out | and2_out;

not U_not (out_n, out);

endmodule