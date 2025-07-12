module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimal sum-of-products: out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d)
assign out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Minimal product-of-sums: out_pos = (a + b + d) & (a + c + d) & (~a + ~b + c + ~d)
assign out_pos = (a | b | d) & (a | c | d) & (~a | ~b | c | ~d);

endmodule