module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire and_out1, and_out2;

// Instantiate AND gates
and and_gate1(a, b, and_out1);
and and_gate2(c, d, and_out2);

// Instantiate OR gate
or or_gate(and_out1, and_out2, out);

// Instantiate NOT gate
not not_gate(out, out_n);

endmodule