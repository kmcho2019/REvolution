module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Correct minimal sum-of-products (SOP) expression:
assign out_sop = (c & d & b) | (c & d & a) | (~a & ~b & c & ~d);

// Correct minimal product-of-sums (POS) expression:
assign out_pos = (a | b | ~c | ~d) & (~a | b | ~c | d) & (~a | ~b | ~c | ~d);

endmodule