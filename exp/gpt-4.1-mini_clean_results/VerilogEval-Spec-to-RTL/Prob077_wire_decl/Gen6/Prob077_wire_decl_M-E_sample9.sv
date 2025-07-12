module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Intermediate wires for AND gate outputs
    wire and_ab;
    wire and_cd;

    // Continuous assignments for AND gates
    assign and_ab = a & b;
    assign and_cd = c & d;

    // OR gate combining the AND outputs
    assign out = and_ab | and_cd;

    // Inverted output of 'out'
    assign out_n = ~out;

endmodule