module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Intermediate wires for AND results
    wire and_ab;
    wire and_cd;

    // First layer: continuous assignments for AND gates
    assign and_ab = a & b;
    assign and_cd = c & d;

    // Second layer: built-in primitive OR gate
    or  (out, and_ab, and_cd);

    // Inverted output using built-in primitive NOT gate
    not (out_n, out);

endmodule