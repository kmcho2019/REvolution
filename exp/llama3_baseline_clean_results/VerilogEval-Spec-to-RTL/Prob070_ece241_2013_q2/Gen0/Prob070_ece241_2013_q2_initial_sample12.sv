module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Sum-of-Products (SOP) implementation for out_sop
assign out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Product-of-Sums (POS) implementation for out_pos
// Since we are not simplifying using Karnaugh maps or other optimization techniques here,
// the direct implementation based on the complement of the input conditions for logic-0 is complex.
// The given conditions for logic-0 are 0, 1, 4, 5, 6, 9, 10, 13, 14, which correspond to the following binary values:
// 0000, 0001, 0100, 0101, 0110, 1001, 1010, 1101, 1110.
// The maxterms for these are:
// (a+b+c+d), (a+b+c+~d), (a+~b+c+d), (a+~b+c+~d), (a+~b+~c+d), (~a+b+c+d), (~a+~b+c+d), (~a+~b+~c+d), (~a+b+~c+d).
// Applying De Morgan's laws and considering the complement conditions, we get:
assign out_pos = (a | b | c | d) & (a | b | c | ~d) & (a | ~b | c | d) & (a | ~b | c | ~d) & (a | ~b | ~c | d) & (~a | b | c | d) & (~a | ~b | c | d) & (~a | ~b | ~c | d) & (~a | b | ~c | d);

endmodule