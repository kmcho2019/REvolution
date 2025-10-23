module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Minimum sum-of-products form for out_sop
// Minterms for 2 (0010), 7 (0111), and 15 (1111)
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Minimum product-of-sums form for out_pos
// Maxterms for 0 (0000), 1 (0001), 4 (0100), 5 (0101), 6 (0110), 9 (1001), 10 (1010), 13 (1101), 14 (1110)
assign out_pos = (a | b | c | d) & (a | ~b | c | d) & (a | b | ~c | d) & (a | b | c | ~d) & (~a | ~b | c | d) & (~a | b | ~c | d) & (~a | b | c | ~d);

endmodule