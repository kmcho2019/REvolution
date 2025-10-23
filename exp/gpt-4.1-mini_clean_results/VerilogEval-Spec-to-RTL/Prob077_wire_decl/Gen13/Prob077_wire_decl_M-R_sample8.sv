module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Intermediate wires for the outputs of the two AND gates
    wire and_ab = a & b;
    wire and_cd = c & d;

    // OR gate output combining the two AND outputs
    assign out = and_ab | and_cd;

    // Inverted output
    assign out_n = ~out;

endmodule