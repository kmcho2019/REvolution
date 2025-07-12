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

    // AND operations using continuous assignment
    assign and_ab = a & b;
    assign and_cd = c & d;

    // OR operation for output
    assign out = and_ab | and_cd;

    // Inverted output
    assign out_n = ~out;

endmodule