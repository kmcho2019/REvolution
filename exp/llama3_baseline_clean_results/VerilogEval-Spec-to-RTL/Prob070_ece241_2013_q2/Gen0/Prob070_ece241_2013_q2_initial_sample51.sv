module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Minimum sum-of-products form for out_sop
// The conditions for a logic-1 are: 2 (0010), 7 (0111), and 15 (1111)
// Hence, the minterms are: 
// - For 2: ~a*b*~c*d
// - For 7: ~a*b*c*d
// - For 15: a*b*c*d
assign out_sop = (~a & b & ~c & d) | (~a & b & c & d) | (a & b & c & d);

// Minimum product-of-sums form for out_pos
// The conditions for a logic-0 are: 0 (0000), 1 (0001), 4 (0100), 5 (0101), 6 (0110), 9 (1001), 10 (1010), 13 (1101), 14 (1110)
// Hence, the maxterms are:
// - For 0: (a+b+c+d)
// - For 1: (a+b+c+~d)
// - For 4: (a+~b+c+d)
// - For 5: (a+~b+c+~d)
// - For 6: (a+~b+~c+d)
// - For 9: (~a+b+c+~d)
// - For 10: (~a+b+~c+d)
// - For 13: (~a+~b+c+~d)
// - For 14: (~a+~b+c+d)
assign out_pos = (a | b | c | d) & (a | b | c | ~d) & (a | ~b | c | d) & (a | ~b | c | ~d) & (a | ~b | ~c | d) & (~a | b | c | ~d) & (~a | b | ~c | d) & (~a | ~b | c | ~d) & (~a | ~b | c | d);

endmodule