module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // XOR implementation for checkerboard K-map pattern
    assign out = (a ^ b) ^ (c ^ d);
endmodule