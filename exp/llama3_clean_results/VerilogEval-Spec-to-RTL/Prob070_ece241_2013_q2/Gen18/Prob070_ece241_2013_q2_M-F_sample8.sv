module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Calculate the minterms for the numbers 2, 7, and 15
wire minterm_2 = ~a & b & ~c & ~d; // Binary for 2: 0010
wire minterm_7 = ~a & b & c & d;   // Binary for 7: 0111
wire minterm_15 = a & b & c & d;    // Binary for 15: 1111

// Sum-of-products (SOP) expression
assign out_sop = minterm_2 | minterm_7 | minterm_15;

// Derive the maxterms for the conditions that should not produce a logic-1 output
// First, find the minterms for the conditions that should result in a logic-0
wire minterm_0 = ~a & ~b & ~c & ~d; // Binary for 0: 0000
wire minterm_1 = ~a & ~b & ~c & d;  // Binary for 1: 0001
wire minterm_4 = ~a & b & ~c & ~d;  // Binary for 4: 0100
wire minterm_5 = ~a & b & ~c & d;   // Binary for 5: 0101
wire minterm_6 = ~a & b & c & ~d;   // Binary for 6: 0110
wire minterm_9 = ~a & ~b & c & d;   // Binary for 9: 1001
wire minterm_10 = ~a & ~b & c & ~d; // Binary for 10: 1010
wire minterm_13 = ~a & ~b & ~c & d; // Binary for 13: 1101
wire minterm_14 = ~a & ~b & ~c & ~d;// Binary for 14: 1110

// Apply De Morgan's laws to find the maxterms
// Maxterm for 0:  (a | b | c | d)
// Maxterm for 1:  (a | b | c | ~d)
// Maxterm for 4:  (a | ~b | c | d)
// Maxterm for 5:  (a | ~b | c | ~d)
// Maxterm for 6:  (a | ~b | ~c | d)
// Maxterm for 9:  (a | b | ~c | ~d)
// Maxterm for 10: (a | b | ~c | d)
// Maxterm for 13: (a | b | c | ~d)
// Maxterm for 14: (a | b | c | d)

// Product-of-sums (POS) expression
assign out_pos = ~(minterm_0 | minterm_1 | minterm_4 | minterm_5 | minterm_6 | minterm_9 | minterm_10 | minterm_13 | minterm_14);

endmodule