module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Minimum sum-of-products form
assign out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Minimum product-of-sums form
// Complement of the sum of minterms for unwanted inputs
// Since we are looking for the product of sums, we can find the sums directly from the given 0 output cases
// and then AND them together. Each sum term is the complement of a maxterm. Given maxterms are:
// 0000, 0001, 0100, 0101, 0110, 1001, 1010, 1101, 1110
// Complement of these gives: 
// 1111, 1110, 1011, 1010, 1001, 0110, 0101, 0010, 0001
// However, in product of sums form, we consider the complement of each variable in the sum term.
// So, we need to find the product of sums from these.
assign out_pos = (a | b | c | d) & (a | b | c | ~d) & (a | ~b | c | d) & (a | ~b | c | ~d) & (a | ~b | ~c | d) & (~a | ~b | c | d) & (~a | ~b | ~c | d) & (~a | b | ~c | d) & (~a | ~b | ~c | ~d);

endmodule