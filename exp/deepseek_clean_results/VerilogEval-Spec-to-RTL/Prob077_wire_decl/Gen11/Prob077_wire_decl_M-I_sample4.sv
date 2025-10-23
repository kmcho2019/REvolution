module TopModule (
    input  a, b,     // First input pair
    input  c, d,     // Second input pair
    output out,      // Direct output
    output out_n     // Inverted output
);

    // Layer 1: Input AND operations
    wire and_ab = a & b;  // AND of first input pair
    wire and_cd = c & d;  // AND of second input pair

    // Layer 2: Output generation
    assign out   = and_ab | and_cd;  // OR of AND results
    assign out_n = ~out;             // Inverted output
endmodule