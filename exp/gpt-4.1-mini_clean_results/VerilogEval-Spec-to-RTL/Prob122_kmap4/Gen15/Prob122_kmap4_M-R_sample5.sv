module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    wire ab_xor;
    wire cd_xor;

    // Compute partial XORs of inputs
    assign ab_xor = a ^ b;
    assign cd_xor = c ^ d;

    // Final output as XOR of partial results
    assign out = ab_xor ^ cd_xor;

endmodule