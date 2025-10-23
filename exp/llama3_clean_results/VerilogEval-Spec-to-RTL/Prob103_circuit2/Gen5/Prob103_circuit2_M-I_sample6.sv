module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Improved implementation using a single XOR operation
assign q = ~(a ^ b ^ c ^ d);

// Alternatively, we could use a Karnaugh map or other logic minimization techniques
// to derive a more compact representation of the logic. However, given the
// simplicity of the current implementation, this may not yield significant improvements.

endmodule