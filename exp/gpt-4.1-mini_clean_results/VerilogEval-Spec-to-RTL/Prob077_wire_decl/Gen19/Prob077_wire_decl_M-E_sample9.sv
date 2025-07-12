module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Intermediate wires for the AND results
    wire and_ab = a & b;
    wire and_cd = c & d;

    // OR of the intermediate wires for output
    assign out = and_ab | and_cd;

    // Inverted output
    assign out_n = ~out;

endmodule