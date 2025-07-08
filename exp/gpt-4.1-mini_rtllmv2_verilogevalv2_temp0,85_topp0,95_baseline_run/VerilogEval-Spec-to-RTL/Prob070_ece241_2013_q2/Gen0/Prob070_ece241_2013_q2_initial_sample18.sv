module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimal sum-of-products expression
assign out_sop = (c & d) | (~a & ~b & c & ~d);

// Minimal product-of-sums expression
assign out_pos = (a | b | d) & (a | c | d) & (b | c | d);

endmodule