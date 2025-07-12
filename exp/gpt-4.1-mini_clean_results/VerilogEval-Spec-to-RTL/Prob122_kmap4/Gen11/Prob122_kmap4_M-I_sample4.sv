module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    wire ab_xor, cd_xor;

    // Balanced XOR tree to implement parity: (a ^ b) ^ (c ^ d)
    assign ab_xor = a ^ b;
    assign cd_xor = c ^ d;
    assign out = ab_xor ^ cd_xor;
endmodule