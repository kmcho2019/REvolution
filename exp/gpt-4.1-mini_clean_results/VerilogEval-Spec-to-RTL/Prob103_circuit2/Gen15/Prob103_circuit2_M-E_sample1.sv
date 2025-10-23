module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire ab_xor, cd_xor;

    assign ab_xor = a ^ b;   // XOR of first pair
    assign cd_xor = c ^ d;   // XOR of second pair
    assign q = ~ (ab_xor ^ cd_xor);  // Invert XOR of two pairs for even parity

endmodule