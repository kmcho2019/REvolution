module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

    // Declare wires to connect the AND gates to the OR gate
    wire and_out_1;
    wire and_out_2;

    // First layer: two AND gates
    and and_gate_1(and_out_1, a, b);
    and and_gate_2(and_out_2, c, d);

    // Second layer: OR gate
    or or_gate(out, and_out_1, and_out_2);

    // Invert 'out' to get 'out_n'
    not not_gate(out_n, out);

endmodule