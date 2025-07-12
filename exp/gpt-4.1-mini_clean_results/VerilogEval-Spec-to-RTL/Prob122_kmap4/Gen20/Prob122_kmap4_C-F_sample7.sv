module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Output corresponds to the parity of inputs a, b, c, d
    // Derived from the given Karnaugh map, output is high for odd number of '1's
    // Implemented as a balanced XOR tree for minimal logic depth and clear structure

    wire xor_ab = a ^ b;    // XOR of inputs a and b
    wire xor_cd = c ^ d;    // XOR of inputs c and d

    assign out = xor_ab ^ xor_cd; // Final parity output (a⊕b⊕c⊕d)

endmodule