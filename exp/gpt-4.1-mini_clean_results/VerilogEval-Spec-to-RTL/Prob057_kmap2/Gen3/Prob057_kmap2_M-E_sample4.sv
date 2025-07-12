module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

// From the Karnaugh map, cells with output = 1:
// cd=00, ab=00: ~c & ~d & ~a & ~b
wire m0 = nc & nd & na & nb;
// cd=00, ab=01: ~c & ~d & ~a & b
wire m1 = nc & nd & na & b;
// cd=00, ab=10: ~c & ~d & a & ~b
wire m2 = nc & nd & a & nb;
// cd=00, ab=11: 0 (no minterm, skip)
// cd=01, ab=00: ~c & d & ~a & ~b
wire m3 = nc & d & na & nb;
// cd=01, ab=10: ~c & d & a & ~b
wire m4 = nc & d & a & nb;
// cd=01, ab=01: 0 (skip)
// cd=01, ab=11: 0 (skip)
// cd=10, ab=00: c & ~d & ~a & ~b
wire m5 = c & nd & na & nb;
// cd=10, ab=01: c & ~d & ~a & b
wire m6 = c & nd & na & b;
// cd=10, ab=10: 0 (skip)
// cd=10, ab=11: 0 (skip)
// cd=11, ab=01: c & d & ~a & b
wire m7 = c & d & na & b;
// cd=11, ab=10: c & d & a & b
wire m8 = c & d & a & b;
// cd=11, ab=11: c & d & a & b (already covered by m8, but K-map says 1, so no duplication needed)
// cd=11, ab=00: 0 (skip)

// Additionally from the map for cd=11, ab=11 cell
// The K-map cell (cd=11, ab=11) = 1 (covered by m8)

// Summing all minterms with 1 outputs:
assign out = m0 | m1 | m2 | m3 | m4 | m5 | m6 | m7 | m8;

endmodule