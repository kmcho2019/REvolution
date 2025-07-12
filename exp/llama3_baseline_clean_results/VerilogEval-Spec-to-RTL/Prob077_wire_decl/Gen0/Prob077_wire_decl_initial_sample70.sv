module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire and_out_1;
wire and_out_2;

// First layer: AND gates
and and_gate_1(a, b, and_out_1);
and and_gate_2(c, d, and_out_2);

// Second layer: OR gate
or or_gate(and_out_1, and_out_2, out);

// Invert out to produce out_n
not not_gate(out, out_n);

endmodule