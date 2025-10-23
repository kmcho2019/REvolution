module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire and_out1;
wire and_out2;

// First layer AND gates
and and_gate1(a, b, and_out1);
and and_gate2(c, d, and_out2);

// Second layer OR gate
or or_gate(and_out1, and_out2, out);

// NOT gate to invert 'out' signal
not not_gate(out, out_n);

endmodule