module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimal sum-of-products:
// out_sop = (~a & ~b & c & ~d) + (~a & b & c & d) + (a & b & c & d)
assign out_sop = (~a & ~b &  c & ~d) |
                 (~a &  b &  c &  d) |
                 ( a &  b &  c &  d);

// Simplified product-of-sums equivalent:
// out_pos = (c + d) & (b + c + ~a)
assign out_pos = (c | d) & (b | c | ~a);

endmodule