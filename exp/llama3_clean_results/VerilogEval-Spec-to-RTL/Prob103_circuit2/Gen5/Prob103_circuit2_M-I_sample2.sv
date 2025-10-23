module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Directly compute the output q as the inverse of the XOR of a, b, c, and d
// using a single assign statement for efficiency and simplicity.
assign q = ~(a ^ b ^ c ^ d);

endmodule