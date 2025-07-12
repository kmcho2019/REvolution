module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Compute q as the inverse of the XOR of all input bits
assign q = ~(a ^ b ^ c ^ d);

endmodule