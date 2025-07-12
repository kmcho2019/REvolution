module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire and_wire1;
wire and_wire2;

and and_gate1 (and_wire1, a, b);
and and_gate2 (and_wire2, c, d);

or or_gate (out, and_wire1, and_wire2);

not not_gate (out_n, out);

endmodule