module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Intermediate wires for AND gate outputs
    wire and_ab = a & b;
    wire and_cd = c & d;

    // OR gate output assigned to 'out'
    assign out = and_ab | and_cd;

    // Inverted output of 'out'
    assign out_n = ~out;

endmodule