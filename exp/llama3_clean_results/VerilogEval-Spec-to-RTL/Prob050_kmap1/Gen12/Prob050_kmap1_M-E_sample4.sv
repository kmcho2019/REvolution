module TopModule(
    input a,
    input b,
    input c,
    output out
);
// Implement the logic using a sum of products (SOP) approach
wire term1, term2, term3, term4;

// Term 1: a'b'c'
assign term1 = ~(a | b | c);

// Term 2: a'bc
assign term2 = ~(a) & b & c;

// Term 3: ab'c
assign term3 = a & ~(b) & c;

// Term 4: abc
assign term4 = a & b & c;

// Term 5: a'bc'
assign term5 = ~(a) & b & ~(c);

// Term 6: ab'c'
assign term6 = a & ~(b) & ~(c);

// Term 7: a'b'c
assign term7 = ~(a) & ~(b) & c;

// Output is the OR of all terms
assign out = term1 | term2 | term3 | term4 | term5 | term6 | term7;
endmodule