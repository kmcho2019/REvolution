module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimum sum-of-products form
assign out_sop = b & ((~a & ~c & ~d) | (~a & c & d) | (a & c & d));

// Minimum product-of-sums form
assign out_pos = (b | ~a | ~c | ~d) & (b | ~a | c | d) & (b | a | c | d);

endmodule