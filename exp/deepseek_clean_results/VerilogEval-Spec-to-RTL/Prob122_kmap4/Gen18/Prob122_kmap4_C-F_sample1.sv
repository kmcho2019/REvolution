module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Implements checkerboard K-map pattern using XOR operations:
    // out = (a^b)^(c^d) creates alternating 0/1 pattern in both dimensions
    assign out = a ^ b ^ c ^ d;

endmodule