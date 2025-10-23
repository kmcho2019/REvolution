module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

    // Intermediate wires for AND gate outputs
    wire and1_result;
    wire and2_result;

    // Continuous assignments for the AND gates
    assign and1_result = a & b;
    assign and2_result = c & d;

    // OR the intermediate AND outputs for final output
    assign out = and1_result | and2_result;

    // Inverted output
    assign out_n = ~out;

endmodule