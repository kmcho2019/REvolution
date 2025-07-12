module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Minimum Sum-of-Products form for out_sop
// The minterms are:
// 2 (0010) = !a & b & !c & !d
// 7 (0111) = !a & b & c & d
// 15 (1111) = a & b & c & d
// Combining these with OR
assign out_sop = (!a & b & !c & !d) | (!a & b & c & d) | (a & b & c & d);

// Minimum Product-of-Sums form for out_pos
// The maxterms are:
// 0 (0000) = a | b | c | d
// 1 (0001) = a | b | !c | d
// 4 (0100) = a | !b | c | d
// 5 (0101) = a | !b | c | !d
// 6 (0110) = a | !b | !c | d
// 9 (1001) = !a | b | c | d
// 10 (1010) = !a | b | c | !d
// 13 (1101) = !a | !b | c | d
// 14 (1110) = !a | !b | c | !d
// Combining these with AND
assign out_pos = (a | b | c | d) & (a | b | !c | d) & (a | !b | c | d) & (a | !b | c | !d) & 
                 (a | !b | !c | d) & (!a | b | c | d) & (!a | b | c | !d) & (!a | !b | c | d) & 
                 (!a | !b | c | !d);

endmodule