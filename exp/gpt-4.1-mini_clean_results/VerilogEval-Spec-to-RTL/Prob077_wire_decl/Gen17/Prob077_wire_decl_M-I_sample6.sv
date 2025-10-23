module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Intermediate wires for AND gate results
    wire and_ab;
    wire and_cd;

    // Continuous assignments for the AND gates
    assign and_ab = a & b;
    assign and_cd = c & d;

    // Continuous assignment for OR gate output
    assign out = and_ab | and_cd;

    // Direct continuous assignment for inverted output
    assign out_n = ~out;

endmodule