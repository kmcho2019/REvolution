module TopModule(
    input  a,  // Input signal a
    input  b,  // Input signal b
    input  c,  // Input signal c
    input  d,  // Input signal d (not used in the logic)
    output q   // Output signal q
);

// The output q is high whenever a is high, or b is high, or c is high
// This logic is efficiently implemented using a single OR operation
assign q = a || b || c;

endmodule