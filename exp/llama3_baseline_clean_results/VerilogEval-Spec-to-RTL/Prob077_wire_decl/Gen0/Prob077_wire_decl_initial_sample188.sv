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

// First layer: AND gates
and and_gate1(and_gate1_out, a, b);
and and_gate2(and_gate2_out, c, d);

// Second layer: OR gate
or or_gate(out, and_gate1_out, and_gate2_out);

// Inverted output
not not_gate(out_n, out);

endmodule