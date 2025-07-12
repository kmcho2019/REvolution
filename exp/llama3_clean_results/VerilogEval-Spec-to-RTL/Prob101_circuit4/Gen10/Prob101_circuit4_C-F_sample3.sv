module TopModule(
    input  a,  // Input signal a (not used in the logic)
    input  b,  // Input signal b
    input  c,  // Input signal c
    input  d,  // Input signal d (not used in the logic)
    output q   // Output signal q
);

// The output q is high whenever b or c is high, regardless of the values of a and d
// This logic is efficiently implemented using a single OR operation
assign q = b || c;

endmodule