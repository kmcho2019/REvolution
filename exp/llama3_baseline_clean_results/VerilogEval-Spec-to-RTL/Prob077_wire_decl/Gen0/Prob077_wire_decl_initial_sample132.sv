module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

// Intermediate wires to hold the outputs of the AND gates
wire and1_out;
wire and2_out;

// First layer: AND gates
and and1(a, b, and1_out);
and and2(c, d, and2_out);

// Second layer: OR gate
or or1(and1_out, and2_out, out);

// Inverted output
not not1(out, out_n);

endmodule