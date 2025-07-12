module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Compute XOR of first input pair (a, b)
    wire ab_xor = a ^ b;

    // Compute XOR of second input pair (c, d)
    wire cd_xor = c ^ d;

    // Final output: parity of all four inputs,
    // achieved by XOR of the two intermediate XORs.
    assign out = ab_xor ^ cd_xor;
endmodule