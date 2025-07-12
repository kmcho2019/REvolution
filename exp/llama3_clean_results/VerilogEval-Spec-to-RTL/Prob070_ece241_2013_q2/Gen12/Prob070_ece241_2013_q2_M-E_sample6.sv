module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Using a truth table to derive the minimum SOP and POS expressions
// The truth table would show the following:
// - For inputs 2 (0010), 7 (0111), and 15 (1111), out_sop and out_pos should be 1.
// - For inputs 0 (0000), 1 (0001), 4 (0100), 5 (0101), 6 (0110), 9 (1001), 10 (1010), 13 (1101), and 14 (1110), out_sop and out_pos should be 0.

// Derive the minimum SOP expression
assign out_sop = 
    // Condition for 2: 0010
    (~a & b & ~c & ~d) |
    // Condition for 7: 0111
    (~a & b & c & d) |
    // Condition for 15: 1111
    (a & b & c & d);

// Derive the minimum POS expression by considering the negation of conditions that should produce a logic-0
assign out_pos = ~(
    // Negation of conditions that should produce a logic-0
    (a & ~b & ~c & ~d) |  // Not directly mentioned but needed for completeness
    (~a & ~b & ~c & ~d) |  // 0: 0000
    (~a & ~b & ~c & d) |   // 1: 0001
    (~a & b & ~c & ~d) |   // 4: 0100
    (~a & b & ~c & d) |    // 5: 0101
    (~a & b & c & ~d) |    // 6: 0110
    (a & ~b & ~c & d) |    // 9: 1001
    (a & ~b & c & ~d) |    // 10: 1010
    (a & b & ~c & ~d) |    // 13: 1101
    (a & b & c & ~d)       // 14: 1110
);

endmodule