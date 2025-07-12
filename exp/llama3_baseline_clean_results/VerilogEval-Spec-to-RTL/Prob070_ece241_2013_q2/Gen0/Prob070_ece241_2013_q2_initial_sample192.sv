module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimum sum-of-products (SOP) form
assign out_sop = b & (d | ~a);

// Minimum product-of-sums (POS) form
assign out_pos = (~a | ~b | ~d) & (~a | ~b | c) & (~a | b | c | d);

endmodule