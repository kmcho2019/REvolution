module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Represent inputs as a 4-bit vector for easy comparison
    wire [3:0] in_vec = {a, b, c, d};

    // Define constants for the values that generate logic 1
    localparam [3:0] VAL_2  = 4'd2;   // 0010
    localparam [3:0] VAL_7  = 4'd7;   // 0111
    localparam [3:0] VAL_15 = 4'd15;  // 1111

    // Define constants for values that generate logic 0 (zero minterms)
    // 0,1,4,5,6,9,10,13,14
    // We'll use these for POS expression.

    // SOP: output is 1 if input equals 2,7 or 15
    assign out_sop = (in_vec == VAL_2) | (in_vec == VAL_7) | (in_vec == VAL_15);

    // For POS, the zero outputs correspond to the following decimal numbers:
    // Zero minterms: 0,1,4,5,6,9,10,13,14
    // Convert each to 4-bit vectors:

    // Sum terms: For each zero minterm M, the sum term is:
    // (a + b + c + d) with each variable complemented if bit in M is 1, uncomplemented if bit is 0
    // i.e. For minterm M = m3 m2 m1 m0 (a,b,c,d):
    // sum_term = (a if m3=0 else ~a) + (b if m2=0 else ~b) + (c if m1=0 else ~c) + (d if m0=0 else ~d)
    // The final POS is the product (AND) of these sum terms.

    // Let's define each sum term individually:

    wire st0  = (a | b | c | d);             // M=0  = 0000
    wire st1  = (a | b | c | ~d);            // M=1  = 0001
    wire st4  = (a | ~b | ~c | d);           // M=4  = 0100
    wire st5  = (a | ~b | ~c | ~d);          // M=5  = 0101
    wire st6  = (a | ~b | c | ~d);           // M=6  = 0110
    wire st9  = (~a | b | c | ~d);           // M=9  = 1001
    wire st10 = (~a | b | ~c | d);           // M=10 = 1010
    wire st13 = (~a | ~b | c | ~d);          // M=13 = 1101
    wire st14 = (~a | ~b | c | d);           // M=14 = 1110

    // Final POS is AND of all zero minterms sum terms
    assign out_pos = st0 & st1 & st4 & st5 & st6 & st9 & st10 & st13 & st14;

endmodule