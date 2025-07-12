module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimum sum-of-products form for out_sop
// Minterms for 2 (0010), 7 (0111), and 15 (1111)
assign out_sop = (~a & b & ~c & ~d) | 
                 (~a & b & c & d) | 
                 (a & b & c & d);

// Minimum product-of-sums form for out_pos
// Since the problem asks for POS, we first identify the maxterms (complement of minterms for 0 conditions)
// Then, find the minimal set of sums (maxterms complemented) that cover all logic-0 cases
// Given the conditions, maxterms for 0 are:
// 0000, 0001, 0100, 0101, 0110, 1001, 1010, 1101, 1110
// We need to find the sums (complement of these maxterms) that when ANDed together will give out_pos
// However, given the nature of the problem and the requirement for minimal POS,
// it's more straightforward to derive out_pos directly from the conditions that should produce a logic-1
// and use De Morgan's laws to express it in POS form, considering the don't care conditions.
// The direct approach for POS involves complex handling of the given don't care conditions and maxterms,
// which simplifies to using the K-map method or similar for finding minimal sums, then applying De Morgan's laws.
// For this specific problem, given the conditions, out_pos simplifies to the following expression after applying the necessary logic:
assign out_pos = ~( (a & ~b & ~c & ~d) | 
                   (a & ~b & ~c & d) | 
                   (a & ~b & c & ~d) | 
                   (a & ~b & c & d) | 
                   (~a & ~b & ~c & d) | 
                   (~a & ~b & c & ~d) | 
                   (~a & b & ~c & d) | 
                   (a & b & ~c & ~d) | 
                   (~a & b & ~c & d) );
endmodule