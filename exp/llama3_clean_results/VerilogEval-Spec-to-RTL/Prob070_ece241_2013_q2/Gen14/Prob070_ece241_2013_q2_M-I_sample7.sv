module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Derive the minimum SOP expression directly from the specified conditions
// and simplify using a Karnaugh map or similar method if necessary
assign out_sop = 
    // Condition for 2: 0010
    (~a & b & ~c & ~d) |
    // Condition for 7: 0111
    (~a & b & c & d) |
    // Condition for 15: 1111
    (a & b & c & d);

// For out_pos, instead of directly negating conditions, 
// derive the minimum POS form by considering the complement conditions
// that should produce a logic-0 and apply De Morgan's laws or Karnaugh map for simplification
assign out_pos = 
    // Directly consider the complement conditions for a logic-0
    // and apply De Morgan's laws or use a Karnaugh map for simplification
    ~( 
        // Conditions for inputs that should produce a logic-0
        // Use a Karnaugh map or similar method to simplify these conditions
        // if direct implementation is too complex or results in mismatches
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

// To optimize for better PPA, ensure the expressions are minimized
// and consider using always blocks for sequential logic if applicable
endmodule