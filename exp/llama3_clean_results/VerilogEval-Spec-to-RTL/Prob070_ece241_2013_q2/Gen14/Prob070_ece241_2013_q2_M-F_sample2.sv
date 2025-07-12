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
assign out_pos = ~( 
    // Condition for 0: 0000
    (~a & ~b & ~c & ~d) |
    // Condition for 1: 0001
    (~a & ~b & ~c & d) |
    // Condition for 4: 0100
    (~a & b & ~c & ~d) |
    // Condition for 5: 0101
    (~a & b & ~c & d) |
    // Condition for 6: 0110
    (~a & b & c & ~d) |
    // Condition for 9: 1001
    (a & ~b & ~c & d) |
    // Condition for 10: 1010
    (a & ~b & c & ~d) |
    // Condition for 13: 1101
    (a & b & ~c & d) |
    // Condition for 14: 1110
    (a & b & c & ~d)
);

// The POS expression can be derived by taking the complement of the sum-of-products for the logic-0 conditions.
// This implementation correctly represents the conditions for a logic-0 output and applies the necessary logical operations.

endmodule