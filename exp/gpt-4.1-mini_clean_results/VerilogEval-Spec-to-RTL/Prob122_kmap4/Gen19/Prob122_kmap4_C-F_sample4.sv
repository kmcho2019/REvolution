module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Implement 4-input parity function from given Karnaugh map
    // Output is high if an odd number of inputs are high (a⊕b⊕c⊕d)
    // Balanced XOR tree minimizes logic depth and glitches

    wire xor_ab = a ^ b;
    wire xor_cd = c ^ d;

    assign out = xor_ab ^ xor_cd;

endmodule