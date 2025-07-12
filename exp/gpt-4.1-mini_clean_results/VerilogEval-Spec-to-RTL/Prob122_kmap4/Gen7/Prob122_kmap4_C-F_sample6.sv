module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Intermediate XOR pairs for comprehensive clarity:
    // ab_xor = a XOR b
    // cd_xor = c XOR d
    // ac_xor = a XOR c
    // bd_xor = b XOR d
    wire ab_xor = a ^ b;
    wire cd_xor = c ^ d;
    wire ac_xor = a ^ c;
    wire bd_xor = b ^ d;

    // Output is parity of all four inputs.
    // This can be computed equivalently by (ab_xor ^ cd_xor) or (ac_xor ^ bd_xor).
    // Here, we use (ab_xor ^ cd_xor) for minimal logic depth.
    assign out = ab_xor ^ cd_xor;

    // The intermediate signals expose all pairwise XORs for improved debug and extensibility.
endmodule