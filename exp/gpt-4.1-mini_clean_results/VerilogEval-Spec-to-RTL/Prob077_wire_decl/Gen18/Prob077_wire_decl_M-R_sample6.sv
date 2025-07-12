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

    // Assign AND operations to intermediate wires
    assign and_ab = a & b;
    assign and_cd = c & d;

    // Assign OR operation to produce 'out'
    assign out = and_ab | and_cd;

    // Inverted output
    assign out_n = ~out;

endmodule