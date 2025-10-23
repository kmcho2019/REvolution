module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire out_b_c;

assign out_b_c = c;

assign out = a ? 1 : (b ? out_b_c : 1);

endmodule