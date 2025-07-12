module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Intermediate wires for first layer AND gates
    wire and_ab;
    wire and_cd;

    // First layer: continuous assignments for AND gates
    assign and_ab = a & b;
    assign and_cd = c & d;

    // Second layer: OR gate primitive instantiated structurally
    or or_gate (out, and_ab, and_cd);

    // Inverted output using NOT gate primitive
    not not_gate (out_n, out);

endmodule