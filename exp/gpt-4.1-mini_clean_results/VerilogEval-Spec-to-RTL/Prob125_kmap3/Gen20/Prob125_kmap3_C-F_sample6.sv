module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // don't care, unused
    output out
);

// Factored minimal logic from K-map:
// out = (a & ~c) | (c & (~b | a))
assign out = (a & ~c) | (c & (~b | a));

endmodule