module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// The Karnaugh map can be simplified into the following expression:
// out = (a & d) | (b & ~c & d) | (~a & b & c) | (~a & ~b & ~c & d) | (~a & ~b & c & ~d)
assign out = (a & d) | (b & ~c & d) | (~a & b & c) | (~a & ~b & ~c & d) | (~a & ~b & c & ~d);

endmodule