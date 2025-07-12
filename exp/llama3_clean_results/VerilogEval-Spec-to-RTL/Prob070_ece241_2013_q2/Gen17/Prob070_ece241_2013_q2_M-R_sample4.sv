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

// Calculate the maxterms for the conditions that should not produce a logic-1 output
// Maxterm for 0:  (a | b | c | d)
// Maxterm for 1:  (a | ~b | ~c | ~d)
// Maxterm for 4:  (~a | b | ~c | ~d)
// Maxterm for 5:  (~a | b | ~c | d)
// Maxterm for 6:  (~a | b | c | ~d)
// Maxterm for 9:  (~a | ~b | c | d)
// Maxterm for 10: (~a | ~b | c | ~d)
// Maxterm for 13: (~a | ~b | ~c | d)
// Maxterm for 14: (~a | ~b | ~c | ~d)

// Product-of-sums (POS) expression
assign out_pos = ~( (a | b | c | d) & 
                    (a | ~b | ~c | ~d) & 
                    (~a | b | ~c | ~d) & 
                    (~a | b | ~c | d) & 
                    (~a | b | c | ~d) & 
                    (~a | ~b | c | d) & 
                    (~a | ~b | c | ~d) & 
                    (~a | ~b | ~c | d) & 
                    (~a | ~b | ~c | ~d) );

endmodule