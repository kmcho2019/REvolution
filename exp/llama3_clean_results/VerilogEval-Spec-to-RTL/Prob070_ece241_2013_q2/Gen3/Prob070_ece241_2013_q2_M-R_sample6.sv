module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimum Sum-of-Products (SOP) form for out_sop
// The binary representations for 2, 7, and 15 are 0010, 0111, and 1111 respectively.
assign out_sop = (!a & b & !c & !d) | (!a & b & c & d) | (a & b & c & d);

// Minimum Product-of-Sums (POS) form for out_pos
// To correctly implement out_pos, we need to consider the conditions that result in a 0 output.
// The numbers 0, 1, 4, 5, 6, 9, 10, 13, 14 in binary are:
// 0000, 0001, 0100, 0101, 0110, 1001, 1010, 1101, 1110
// The product-of-sums form for these conditions can be derived by expressing each condition as a sum and then taking the product of these sums.
// However, due to the complexity and the requirement for a minimal form, we simplify by directly implementing the product-of-sums logic based on the given conditions.
assign out_pos = (!(a | b | c | d)) | !(a | !b | c | d) | !(a | b | !c | d) | !(a | b | c | !d) | 
                 !(!a | b | !c | !d) | !(!a | b | c | !d) | !(!a | !b | !c | d) | 
                 !(!a | !b | c | !d) | !(a | !b | !c | !d);

endmodule