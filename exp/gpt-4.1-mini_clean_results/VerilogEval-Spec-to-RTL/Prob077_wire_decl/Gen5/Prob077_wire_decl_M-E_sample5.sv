module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire and1_out, and2_out;

and and_gate1 (and1_out, a, b);
and and_gate2 (and2_out, c, d);

or or_gate (out, and1_out, and2_out);

not not_gate (out_n, out);

endmodule