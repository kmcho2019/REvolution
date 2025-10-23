module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Common sub-expressions
    wire b_and_c = b & c;
    wire bcd = b_and_c & d;
    wire a_prime = ~a;
    wire d_prime = ~d;

    // SOP implementation (a'bcd' + bcd)
    wire term1 = a_prime & b_and_c & d_prime;
    assign out_sop = term1 | bcd;

    // POS implementation (product of sums for false cases)
    // Using De Morgan's on the SOP of false cases
    // POS = (a+b+c+d)(a+b+c+d')(a+b'+c+d)(a+b'+c+d')(a+b'+c'+d)(a'+b+c+d')(a'+b+c'+d)(a'+b'+c+d)(a'+b'+c'+d)
    // But we can implement more efficiently by observing patterns:
    
    // Group 1: When a=0 and b=1 and c=1 → covers 6,7,14,15 (but 7,15 are true)
    // Group 2: When a=1 and b=0 and c=0 → covers 8,9,12,13 (but 8,12 are don't care)
    // Group 3: When a=1 and b=1 and c=0 → covers 10,11,14,15 (but 11 is don't care, 15 is true)
    
    // Instead, we'll implement POS by inverting the conditions that make out_sop=0
    // Which is equivalent to ~out_sop, but we'll build it properly as POS
    
    // POS terms for false cases (0,1,4,5,6,9,10,13,14)
    // Each OR term represents a false case
    
    // We can find common patterns in the false cases:
    // When a=0 OR b=0 OR c=0 OR d=0 (but need to be more specific)
    
    // More efficient implementation using observed patterns:
    wire pos_term1 = a | b | c | d;         // Covers 0 (0000)
    wire pos_term2 = a | b | c | ~d;        // Covers 1 (0001)
    wire pos_term3 = a | ~b | c | d;        // Covers 4 (0100)
    wire pos_term4 = a | ~b | c | ~d;       // Covers 5 (0101)
    wire pos_term5 = a | ~b | ~c | d;       // Covers 6 (0110)
    wire pos_term6 = ~a | b | c | ~d;       // Covers 9 (1001)
    wire pos_term7 = ~a | b | ~c | d;       // Covers 10 (1010)
    wire pos_term8 = ~a | ~b | c | ~d;      // Covers 13 (1101)
    wire pos_term9 = ~a | ~b | ~c | d;      // Covers 14 (1110)
    
    // Combine all POS terms
    assign out_pos = pos_term1 & pos_term2 & pos_term3 & pos_term4 &
                    pos_term5 & pos_term6 & pos_term7 & pos_term8 &
                    pos_term9;

endmodule