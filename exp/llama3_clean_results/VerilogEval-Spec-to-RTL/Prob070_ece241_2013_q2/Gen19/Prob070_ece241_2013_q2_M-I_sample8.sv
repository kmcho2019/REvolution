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
wire maxterm_0 = (a | b | c | d);  // Maxterm for 0
wire maxterm_1 = (a | b | c | ~d); // Maxterm for 1
wire maxterm_4 = (a | ~b | c | d); // Maxterm for 4
wire maxterm_5 = (a | ~b | c | ~d); // Maxterm for 5
wire maxterm_6 = (a | ~b | ~c | d); // Maxterm for 6
wire maxterm_9 = (a | b | ~c | ~d); // Maxterm for 9
wire maxterm_10 = (a | b | ~c | d); // Maxterm for 10
wire maxterm_13 = (a | b | c | ~d); // Maxterm for 13
wire maxterm_14 = (a | b | c | d);  // Maxterm for 14

// Product-of-sums (POS) expression
assign out_pos = ~(maxterm_0 & maxterm_1 & maxterm_4 & maxterm_5 & maxterm_6 & maxterm_9 & maxterm_10 & maxterm_13 & maxterm_14);

endmodule