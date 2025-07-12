module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Minimum sum-of-products form for out_sop
// The numbers 2, 7, and 15 in binary are 0010, 0111, and 1111, respectively.
// We can represent these as sum-of-products:
// - For 2 (0010):!a &!b & c & d
// - For 7 (0111):!a & b & c & d
// - For 15 (1111): a & b & c & d
assign out_sop = (!a &!b & c & d) | (!a & b & c & d) | (a & b & c & d);

// Minimum product-of-sums form for out_pos
// The numbers 0, 1, 4, 5, 6, 9, 10, 13, 14 in binary are:
// 0000, 0001, 0100, 0101, 0110, 1001, 1010, 1101, 1110, respectively.
// We need to find the product-of-sums that covers the cases when the output should be 0.
// This involves finding a condition that is true for all these numbers and then inverting it.
// However, given the requirement, we directly aim for the minimum product-of-sums that represents the conditions for 2, 7, and 15.
// This can be simplified by considering the complement conditions for 0, 1, 4, 5, 6, 9, 10, 13, 14 and then applying De Morgan's laws.
// But for simplicity and adhering to the minimum product-of-sums requirement directly:
// We look for conditions that must be false for the given numbers (2, 7, 15) to be true.
assign out_pos =!(a |!b |!c |!d) &!(a | b |!c |!d) &!(a | b | c |!d);

endmodule