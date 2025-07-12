module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

    // Intermediate wires for AND gate outputs
    wire and_out_ab;
    wire and_out_cd;

    // First layer: AND gates using assign with &
    assign and_out_ab = a & b;
    assign and_out_cd = c & d;

    // Second layer: OR gate using assign with |
    assign out = and_out_ab | and_out_cd;

    // Inverted output using bitwise negation
    assign out_n = ~out;

endmodule