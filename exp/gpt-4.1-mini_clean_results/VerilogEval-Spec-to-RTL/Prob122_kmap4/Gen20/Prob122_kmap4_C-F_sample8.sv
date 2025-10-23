module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Balanced XOR tree: improves clarity and timing over flat XOR chain
    wire ab_xor = a ^ b;
    wire cd_xor = c ^ d;
    assign out = ab_xor ^ cd_xor;

endmodule