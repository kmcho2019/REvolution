module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Correct derivation of SOP expression
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Correct derivation of POS expression
// First, identify the conditions for output 0: 0, 1, 4, 5, 6, 9, 10, 13, 14
// Then, find the maxterms for these conditions and apply De Morgan's laws
// The maxterms for 0, 1, 4, 5, 6, 9, 10, 13, 14 are:
// 0: a'b'c'd', 1: a'b'c'd, 4: a'bcd', 5: a'bc'd, 6: a'bc'd', 9: ab'c'd, 10: ab'cd', 13: ab'c'd, 14: abc'd
// Apply De Morgan's laws and simplify to get the POS expression
assign out_pos = ~( (a | b | c | d)' & 
                   (a | b' | c | d)' & 
                   (a | b' | c' | d)' & 
                   (a | b | c' | d')' & 
                   (a | b | c | d')' & 
                   (a' | b' | c' | d)' & 
                   (a' | b' | c | d)' & 
                   (a' | b | c' | d)' & 
                   (a' | b | c | d')' );

endmodule