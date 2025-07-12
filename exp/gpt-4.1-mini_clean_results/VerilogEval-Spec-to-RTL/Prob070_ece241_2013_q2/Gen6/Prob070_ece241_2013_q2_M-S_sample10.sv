module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Sum-of-products: out = (~a & ~b & c & ~d) | (b & c & d)
assign out_sop = (~a & ~b & c & ~d) | (b & c & d);

// Product-of-sums: out = (a + b + ~c + d) & (a + ~b + ~c + ~d)
assign out_pos = (a | b | ~c | d) & (a | ~b | ~c | ~d);

endmodule