module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

    // Intermediate wires connecting the AND gates to the OR gate
    wire and_ab;
    wire and_cd;

    // Implement two AND gates as continuous assignments
    assign and_ab = a & b;
    assign and_cd = c & d;

    // Implement OR gate output 'out'
    assign out = and_ab | and_cd;

    // Inverted output as continuous assignment for minimal overhead
    assign out_n = ~out;

endmodule