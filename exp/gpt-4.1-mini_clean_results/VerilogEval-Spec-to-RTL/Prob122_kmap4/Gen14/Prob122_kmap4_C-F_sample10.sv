module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Balanced XOR tree for parity function: (a ^ b) ^ (c ^ d)
    wire ab_xor = a ^ b;
    wire cd_xor = c ^ d;
    assign out = ab_xor ^ cd_xor;

endmodule