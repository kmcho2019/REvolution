module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

    // Declare intermediate wires
    wire and_out1;
    wire and_out2;

    // First layer: AND gates
    and and_gate1(and_out1, a, b);
    and and_gate2(and_out2, c, d);

    // Second layer: OR gate
    or or_gate(out, and_out1, and_out2);

    // NOT gate for inverted output
    not not_gate(out_n, out);

endmodule