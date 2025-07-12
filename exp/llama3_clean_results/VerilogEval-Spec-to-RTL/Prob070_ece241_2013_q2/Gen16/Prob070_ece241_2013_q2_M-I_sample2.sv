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
// and applying De Morgan's laws
assign out_pos = 
    // The POS expression can be derived by taking the complement of the sum-of-products for the logic-0 conditions
    // First, we find the sum-of-products for the logic-0 conditions:
    // (~a & ~b & ~c & ~d) | (~a & ~b & ~c & d) | (~a & b & ~c & ~d) | (~a & b & ~c & d) | 
    // (~a & b & c & ~d) | (a & ~b & ~c & d) | (a & ~b & c & ~d) | (a & b & ~c & d) | (a & b & c & ~d)
    // Applying De Morgan's laws, we complement each term and find the product:
    // (a | b | c | d) & (a | b | c & ~d) & (a | ~b | c | d) & (a | ~b | c & ~d) & 
    // (a | ~b | ~c | d) & (a | ~b | ~c & ~d) & (~a | b | c | d) & (~a | b | c & ~d) & 
    // (~a | b | ~c | d) & (~a | b | ~c & ~d) & (~a | ~b | c | d) & (~a | ~b | c & ~d) & 
    // (~a | ~b | ~c | d) & (~a | ~b | ~c & ~d)
    // Simplifying this expression, we get:
    (~a | b) & (~b | c) & (~c | d) & (~d | a);

endmodule