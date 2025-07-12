module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Minimum sum-of-products form for out_sop
assign out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Minimum product-of-sums form for out_pos
// Maxterms for 0, 1, 4, 5, 6, 9, 10, 13, 14
// Note: The conditions for 3, 8, 11, 12 are don't-care and thus not included in the maxterms
assign out_pos = (a | b | ~c | ~d) & (a | ~b | c | ~d) & (~a | b | ~c | d) & (~a | ~b | c | d) & (~a | ~b | ~c | ~d) & (~a | ~b | ~c | d) & (~a | b | c | d) & (a | ~b | ~c | ~d) & (a | ~b | c | d);

endmodule