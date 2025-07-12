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

// Derive the sum-of-products for the logic-0 conditions
// Conditions for logic-0: 0, 1, 4, 5, 6, 9, 10, 13, 14
// Using K-map or manual simplification, we can derive the sum-of-products:
// The conditions are:
// 0: 0000, 1: 0001, 4: 0100, 5: 0101, 6: 0110, 9: 1001, 10: 1010, 13: 1101, 14: 1110

// Sum-of-products for logic-0 conditions
// Note: The expression below directly represents the conditions that should produce a logic-0
// We will apply De Morgan's laws to obtain the POS expression
wire logic0_sop = 
    (~a & ~b & ~c & ~d) |  // 0: 0000
    (~a & ~b & ~c & d) |   // 1: 0001
    (~a & b & ~c & ~d) |   // 4: 0100
    (~a & b & ~c & d) |    // 5: 0101
    (~a & b & c & ~d) |    // 6: 0110
    (a & ~b & ~c & d) |    // 9: 1001
    (a & ~b & c & ~d) |    // 10: 1010
    (a & ~b & ~c & d) |    // 13: 1101
    (a & ~b & c & d);      // 14: 1110

// Apply De Morgan's laws to obtain the POS expression
// The POS expression is the negation of the sum-of-products for logic-0 conditions
// out_pos should be 1 when none of the logic-0 conditions are met
assign out_pos = ~logic0_sop;

endmodule