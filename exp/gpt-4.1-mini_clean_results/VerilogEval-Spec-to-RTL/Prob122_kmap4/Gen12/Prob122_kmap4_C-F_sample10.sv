module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // XOR of inputs a and b
    wire ab_xor = a ^ b;

    // XOR of inputs c and d
    wire cd_xor = c ^ d;

    // Final output: XOR of ab_xor and cd_xor, equivalent to parity of all inputs
    assign out = ab_xor ^ cd_xor;

endmodule