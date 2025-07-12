module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire xor_ab, xor_cd;

// Compute partial XORs
assign xor_ab = a ^ b;
assign xor_cd = c ^ d;

// Final output: inverted XOR of partial XORs
assign q = ~(xor_ab ^ xor_cd);

endmodule