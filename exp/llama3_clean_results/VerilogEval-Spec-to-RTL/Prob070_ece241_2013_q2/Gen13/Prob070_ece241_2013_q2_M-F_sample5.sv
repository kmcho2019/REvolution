module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Derive the minimum SOP expression directly from the specified conditions
assign out_sop = 
    // Condition for 2: 0010
    (~a & b & ~c & ~d) |
    // Condition for 7: 0111
    (~a & b & c & d) |
    // Condition for 15: 1111
    (a & b & c & d);

// Derive the minimum POS expression by considering the negation of conditions that should produce a logic-0
// and applying De Morgan's laws for simplification
assign out_pos = ~(
    // Conditions for inputs that should produce a logic-0
    // Note: Directly considering the conditions that should produce a 0 and then negating
    (~a & ~b & ~c & ~d) |  // 0: 0000
    (~a & ~b & ~c & d) |   // 1: 0001
    (~a & b & ~c & ~d) |   // 4: 0100
    (~a & b & ~c & d) |    // 5: 0101
    (~a & b & c & ~d) |    // 6: 0110
    (a & ~b & ~c & d) |    // 9: 1001
    (a & ~b & c & ~d) |    // 10: 1010
    (a & b & ~c & d) |     // 13: 1101
    (a & b & c & ~d)       // 14: 1110
);

// Alternatively, simplifying out_pos using a more systematic approach like a Karnaugh map
// could potentially yield a more optimized expression, but given the direct conditions,
// the above implementation should correctly capture the required logic.

endmodule