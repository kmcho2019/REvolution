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
    // The POS expression can be derived by finding the product of the complements
    // of the conditions for logic-0 outputs.
    (a | b | c | d) & (a | b | c | ~d) & (a | b | ~c | d) & (a | b | ~c | ~d) & 
    (a | ~b | c | d) & (a | ~b | c | ~d) & (a | ~b | ~c | d) & (a | ~b | ~c | ~d) & 
    (~a | b | c | d) & (~a | b | c | ~d) & (~a | b | ~c | d) & (~a | b | ~c | ~d) & 
    (~a | ~b | c | d) & (~a | ~b | c | ~d) & (~a | ~b | ~c | d) & (~a | ~b | ~c | ~d);

// However, the above expression is not the most efficient. 
// We can simplify it by using the K-maps or by analyzing the conditions.
// After simplification, the out_pos expression can be written as:
assign out_pos = ~( 
    (~a & ~b & ~c & ~d) | 
    (~a & ~b & ~c & d) | 
    (~a & b & ~c & ~d) | 
    (~a & b & ~c & d) | 
    (~a & b & c & ~d) | 
    (a & ~b & ~c & d) | 
    (a & ~b & c & ~d) | 
    (a & b & ~c & d) | 
    (a & b & c & ~d)
);

endmodule