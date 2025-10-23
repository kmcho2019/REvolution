module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Intermediate XOR of first pair of inputs
    wire xor_ab = a ^ b;
    // Intermediate XOR of second pair of inputs
    wire xor_cd = c ^ d;
    // Final output is XOR of intermediate results
    assign out = xor_ab ^ xor_cd;
endmodule