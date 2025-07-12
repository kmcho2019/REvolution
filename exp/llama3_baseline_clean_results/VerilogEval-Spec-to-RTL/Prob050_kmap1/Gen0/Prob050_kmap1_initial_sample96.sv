module TopModule(
    input  a,
    input  b,
    input  c,
    output out
);

assign out = (a & ~b & ~c) | (~a & b & ~c) | (~a & ~b & c) | (a & b & ~c) | (a & ~b & c) | (a & b & c) | (~a & ~b & c) | (a & ~b & ~c);

// Alternatively, the simplified expression based on the Karnaugh map could be:
// assign out = (~a & c) | (a);

endmodule