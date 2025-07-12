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

// Derive the POS expression by considering the negation of binary representations
// that should produce a logic-0 and applying De Morgan's laws
assign out_pos = ~(
    // Negation of conditions that should produce a logic-0
    (~a & ~b & ~c & ~d) |  // 0: 0000
    (~a & ~b & ~c & d) |   // 1: 0001
    (~a & b & ~c & ~d) |   // 4: 0100
    (~a & b & ~c & d) |    // 5: 0101
    (~a & b & c & ~d) |    // 6: 0110
    (a & ~b & ~c & d) |    // 9: 1001
    (a & ~b & c & ~d) |    // 10: 1010
    (a & ~b & ~c & d) |    // 13: 1101
    (a & b & ~c & ~d) |    // Not 13, but actually part of the conditions for logic-0
    (a & b & c & ~d)       // 14: 1110
);

endmodule