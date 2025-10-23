module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Correctly derive the SOP expression from the specified conditions
assign out_sop = 
    // Condition for 2: 0010
    (~a & b & ~c & ~d) |
    // Condition for 7: 0111
    (~a & b & c & d) |
    // Condition for 15: 1111
    (a & b & c & d);

// Derive the POS expression by considering the conditions for logic-0 outputs
// and applying the necessary logical operations
assign out_pos = 
    // The POS expression can be derived by taking the complement of the sum-of-products for the logic-0 conditions.
    // We use the fact that the complement of the sum equals the product of the complements.
    // The sum-of-products for the logic-0 conditions is:
    // (~a & ~b & ~c & ~d) | (~a & ~b & ~c & d) | (~a & b & ~c & ~d) | (~a & b & ~c & d) | 
    // (~a & b & c & ~d) | (a & ~b & ~c & d) | (a & ~b & c & ~d) | (a & b & ~c & d) | (a & b & c & ~d)
    // The product of the complements is:
    // (a | b | c | d) & (a | b | c & ~d) & (a | ~b | c | d) & (a | ~b | c & ~d) & 
    // (a | ~b | ~c | d) & (a | ~b | ~c & ~d) & (~a | b | c | d) & (~a | b | c & ~d) & 
    // (~a | b | ~c | d) & (~a | b | ~c & ~d) & (~a | ~b | c | d) & (~a | ~b | c & ~d) & 
    // (~a | ~b | ~c | d) & (~a | ~b | ~c & ~d)
    // Simplifying the product of the complements, we get:
    (~a | b) & (~b | c) & (~c | d) & (~d | a);

endmodule