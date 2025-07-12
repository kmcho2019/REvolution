module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // don't care, ignored
    output out
);

// Simplified boolean expression from K-map:
// out = (~c & a) | (c & (~b | a))
assign out = (~c & a) | (c & (~b | a));

endmodule