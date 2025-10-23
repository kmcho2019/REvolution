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

    // OR gate output
    assign out = and_ab | and_cd;

    // NOT gate output for inverted output
    assign out_n = ~out;

endmodule