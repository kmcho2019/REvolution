module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire ab_xor, cd_xor;

    // Balanced XOR tree: XOR pairs first
    assign ab_xor = a ^ b;
    assign cd_xor = c ^ d;

    // Final output is XNOR of the two XORs (even parity)
    assign q = ~(ab_xor ^ cd_xor);

endmodule