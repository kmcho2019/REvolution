module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimal sum-of-products (SOP) including don't-cares:
assign out_sop = (b & c & d) | (~a & ~b & c & ~d);

// Minimal product-of-sums (POS) including don't-cares:
assign out_pos = (a | b | ~c | d) & (a | ~b | ~c | ~d);

endmodule