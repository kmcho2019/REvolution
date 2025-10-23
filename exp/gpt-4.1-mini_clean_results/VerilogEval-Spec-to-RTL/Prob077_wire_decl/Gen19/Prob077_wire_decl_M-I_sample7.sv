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

    // First layer: compute AND results using continuous assignments
    assign and_ab = a & b;
    assign and_cd = c & d;

    // Second layer: OR of the AND results
    assign out = and_ab | and_cd;

    // Inverted output
    assign out_n = ~out;

endmodule