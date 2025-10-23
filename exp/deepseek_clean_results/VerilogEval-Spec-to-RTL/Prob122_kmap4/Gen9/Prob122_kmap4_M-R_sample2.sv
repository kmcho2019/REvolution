module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Checkerboard pattern implemented via XOR of row (a^b) and column (c^d) patterns
    assign out = (a ^ b) ^ (c ^ d);
endmodule