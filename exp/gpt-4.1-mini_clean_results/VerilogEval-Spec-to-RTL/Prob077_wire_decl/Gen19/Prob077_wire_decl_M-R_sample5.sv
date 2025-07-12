module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Intermediate wires connecting AND gate outputs
    wire and_ab;
    wire and_cd;

    // Implement AND gates with continuous assignments
    assign and_ab = a & b;
    assign and_cd = c & d;

    // OR gate output from the two AND wires
    assign out = and_ab | and_cd;

    // Inverted output
    assign out_n = ~out;

endmodule