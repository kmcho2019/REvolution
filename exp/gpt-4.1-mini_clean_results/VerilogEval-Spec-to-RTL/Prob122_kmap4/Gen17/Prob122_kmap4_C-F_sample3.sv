module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Balanced XOR tree implementation for parity:
    // Group inputs to reduce logic depth and glitches
    wire ab_xor = a ^ b;
    wire cd_xor = c ^ d;
    assign out = ab_xor ^ cd_xor;

endmodule