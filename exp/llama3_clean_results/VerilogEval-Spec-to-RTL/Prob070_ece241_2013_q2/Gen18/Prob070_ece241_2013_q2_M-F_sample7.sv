module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Define the minterms for SOP
wire minterm_2 = ~a & b & ~c & ~d;
wire minterm_7 = ~a & b & c & d;
wire minterm_15 = a & b & c & d;

// Define the SOP expression
assign out_sop = minterm_2 | minterm_7 | minterm_15;

// Define the maxterms for POS
wire maxterm_0 = ~a | ~b | ~c | ~d;
wire maxterm_1 = ~a | ~b | ~c | d;
wire maxterm_4 = ~a | b | ~c | ~d;
wire maxterm_5 = ~a | b | ~c | d;
wire maxterm_6 = ~a | b | c | ~d;
wire maxterm_9 = a | ~b | ~c | d;
wire maxterm_10 = a | ~b | c | ~d;
wire maxterm_13 = a | b | ~c | d;
wire maxterm_14 = a | b | c | ~d;

// Simplify the maxterms
wire simplified_maxterm_0_to_1 = ~a | ~b | ~c;
wire simplified_maxterm_4_to_6 = ~a | b | ~c;
wire simplified_maxterm_9_to_10 = a | ~b | ~c;
wire simplified_maxterm_13_to_14 = a | b | ~c;

// Define the POS expression
assign out_pos = (simplified_maxterm_0_to_1 | d) & (simplified_maxterm_0_to_1 | ~d) &
                 (simplified_maxterm_4_to_6 | d) & (simplified_maxterm_4_to_6 | ~d) &
                 (simplified_maxterm_9_to_10 | d) & (simplified_maxterm_9_to_10 | ~d) &
                 (simplified_maxterm_13_to_14 | d) & (simplified_maxterm_13_to_14 | ~d);

endmodule