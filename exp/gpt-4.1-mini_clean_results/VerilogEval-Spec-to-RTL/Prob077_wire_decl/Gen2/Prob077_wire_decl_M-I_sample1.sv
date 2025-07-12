module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire and0_out;
wire and1_out;

and and_gate0(and0_out, a, b);
and and_gate1(and1_out, c, d);

or  or_gate (out, and0_out, and1_out);

not not_gate(out_n, out);

endmodule