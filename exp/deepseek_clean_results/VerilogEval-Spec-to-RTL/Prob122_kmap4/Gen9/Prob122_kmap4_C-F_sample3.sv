module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Implements checkerboard pattern using XOR operations:
    // a^b creates row pattern, c^d creates column pattern
    // XOR of both creates the final checkerboard
    assign out = (a ^ b) ^ (c ^ d);
endmodule