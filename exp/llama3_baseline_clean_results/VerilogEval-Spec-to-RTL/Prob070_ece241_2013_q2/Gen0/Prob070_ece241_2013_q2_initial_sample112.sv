module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimum sum-of-products form for logic-1 outputs
assign out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

// To determine the minimum product-of-sums form, we should consider the logic-0 outputs
// The following numbers produce a logic-0: 0, 1, 4, 5, 6, 9, 10, 13, 14
// We can represent these as sums of variables that produce a logic-0

// Out of the given numbers, we need to consider the following sums for a logic-0 output
// Note: We exclude numbers 3, 8, 11, 12 as they never occur
assign out_pos = (a | ~b | ~c | ~d) & (a | ~b | ~c | d) & (~a | b | ~c | ~d) & (~a | b | ~c | d) & (~a | ~b | c | ~d) & (~a | ~b | c | d) & (~a | b | c | ~d) & (~a | b | c | d) & (a | ~b | ~c | ~d) & (a | ~b | ~c | d) & (a | b | ~c | ~d) & (a | b | ~c | d);

endmodule