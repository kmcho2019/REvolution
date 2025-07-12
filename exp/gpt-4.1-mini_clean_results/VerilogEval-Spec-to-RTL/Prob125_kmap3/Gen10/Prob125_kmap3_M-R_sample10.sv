module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // don't care, ignored
    output out
);

// Simplify expression from the Karnaugh map:
// Original: out = (~c & a) | (c & ~b) | (c & a)
// Factor c: out = (~c & a) | (c & (~b | a))

assign out = (~c & a) | (c & (~b | a));

endmodule