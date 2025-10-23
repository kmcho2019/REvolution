module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Intermediate wires for the AND gate outputs
    wire and1_out, and2_out;

    // Instantiate two AND gates
    and and_gate1 (and1_out, a, b);
    and and_gate2 (and2_out, c, d);

    // OR gate to combine the two AND outputs
    or or_gate (out, and1_out, and2_out);

    // NOT gate to produce the inverted output
    not not_gate (out_n, out);

endmodule