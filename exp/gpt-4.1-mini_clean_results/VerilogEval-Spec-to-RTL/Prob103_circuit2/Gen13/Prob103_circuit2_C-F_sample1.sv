module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire ab_xor, cd_xor;

    // Balanced XOR tree: pairwise XOR followed by XOR of results
    assign ab_xor = a ^ b;
    assign cd_xor = c ^ d;
    assign q = ~(ab_xor ^ cd_xor); // Even parity output

endmodule