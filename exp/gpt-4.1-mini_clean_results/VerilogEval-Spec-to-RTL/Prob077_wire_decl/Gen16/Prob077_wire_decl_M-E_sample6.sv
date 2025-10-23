module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Intermediate wires connecting AND gates to OR gate
    wire and_ab;
    wire and_cd;

    // AND gates output
    assign and_ab = a & b;
    assign and_cd = c & d;

    // OR gate output
    assign out = and_ab | and_cd;

    // Inverted output
    assign out_n = ~out;

endmodule