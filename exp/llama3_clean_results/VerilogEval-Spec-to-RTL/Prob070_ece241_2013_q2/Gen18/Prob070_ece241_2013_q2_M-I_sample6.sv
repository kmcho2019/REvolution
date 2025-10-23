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

// Simplify the POS expression by removing redundant terms
assign out_pos = (maxterm_0 & maxterm_1 & maxterm_4) | (maxterm_5 & maxterm_6 & maxterm_9) | (maxterm_10 & maxterm_13 & maxterm_14);

// Alternatively, we can use a more compact representation for the POS expression
// assign out_pos = ~(a & b & ~c & ~d) & ~(a & b & c & ~d) & ~(a & ~b & c & d) & ~(~a & b & c & ~d);

endmodule