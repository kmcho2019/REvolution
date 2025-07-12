module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimum sum-of-products form
assign out_sop = (~a & ~b & ~c & d) | (~a & b & c & d) | (a & b & c & d);

// Minimum product-of-sums form
assign out_pos = (a | b) & (a | c) & (a | d) & (~a | ~b) & (~a | ~c) & (~b | ~d) & (b | c | d);

endmodule