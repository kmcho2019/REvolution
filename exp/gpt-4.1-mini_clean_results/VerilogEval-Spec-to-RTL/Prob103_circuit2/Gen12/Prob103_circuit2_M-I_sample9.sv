module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire ab_xor, cd_xor;

    // Compute XOR of pairs to implement parity with balanced tree of 2-input XOR gates
    assign ab_xor = a ^ b;
    assign cd_xor = c ^ d;
    // Final output is inverse of parity (even parity)
    assign q = ~(ab_xor ^ cd_xor);

endmodule