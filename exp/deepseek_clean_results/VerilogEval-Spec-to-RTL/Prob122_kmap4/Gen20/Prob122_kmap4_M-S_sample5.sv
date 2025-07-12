module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // The checkerboard pattern is equivalent to XOR of all four inputs
    assign out = a ^ b ^ c ^ d;

endmodule