// Refactored version maintaining the original simplicity and efficiency
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Direct calculation of output q as the inverse of the XOR of all input bits
assign q = ~(a ^ b ^ c ^ d);

endmodule