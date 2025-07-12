module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Intermediate wires connecting the outputs of AND operations
    wire and_out_ab;
    wire and_out_cd;

    // Continuous assignments for AND gates
    assign and_out_ab = a & b;
    assign and_out_cd = c & d;

    // Continuous assignment for OR gate output
    assign out = and_out_ab | and_out_cd;

    // Continuous assignment for inverted output
    assign out_n = ~out;

endmodule