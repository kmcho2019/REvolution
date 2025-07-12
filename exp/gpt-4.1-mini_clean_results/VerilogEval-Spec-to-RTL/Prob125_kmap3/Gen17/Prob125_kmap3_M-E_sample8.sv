module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,  // don't care, ignored
    output out
);

// From the K-map, the minimal expression is:
// out = (a & ~c) | (c & ~b) | (a & c)
// which simplifies to:
// out = (a & ~c) | (c & (~b | a))

assign out = (a & ~c) | (c & (~b | a));

endmodule