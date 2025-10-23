module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Calculate out_sop (sum-of-products)
// The given conditions for 1 are: 2 (0010), 7 (0111), 15 (1111)
// Expressing these in sum-of-products form
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Calculate out_pos (product-of-sums)
// The given conditions for 0 are: 0 (0000), 1 (0001), 4 (0100), 5 (0101), 6 (0110), 9 (1001), 10 (1010), 13 (1101), 14 (1110)
// To simplify, notice the pattern and use De Morgan's law
// However, since we're looking for a product-of-sums, we directly consider the complements of the minterms for 0
assign out_pos = ~(a & ~b & ~c & ~d) & ~(~a & b & ~c & ~d) & ~(~a & ~b & c & ~d) & ~(~a & ~b & ~c & d) & 
                 ~(~a & ~b & ~c & d) & ~(~a & b & c & ~d) & ~(~a & ~b & ~c & ~d) & 
                 ~(a & b & ~c & ~d) & ~(a & ~b & c & ~d) & ~(a & ~b & ~c & d) & 
                 ~(~a & b & c & d) & ~(a & ~b & c & d) & ~(a & b & ~c & d) & ~(a & b & c & ~d);

// Simplify the product-of-sums expression by removing redundant terms and applying De Morgan's law
// The simplified expression can be derived by considering the conditions that produce a 0 and taking their complements
assign out_pos = (a | b | c | d) & (a | ~b | c | d) & (a | b | ~c | d) & (a | b | c | ~d) & 
                 (~a | b | c | d) & (~a | ~b | c | d) & (~a | ~b | ~c | d) & 
                 (~a | ~b | ~c | ~d);

// However, the correct approach to simplify out_pos should involve identifying the essential prime implicants or using a Karnaugh map for a more systematic reduction.
// Given the nature of the problem, let's directly address the calculation based on the requirement for product-of-sums.

endmodule