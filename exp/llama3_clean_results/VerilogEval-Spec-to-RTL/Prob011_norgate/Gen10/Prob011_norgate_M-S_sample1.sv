// Simplified Module TopModule implementing a NOR gate.
module TopModule(
    input  a,  // Input signal a
    input  b,  // Input signal b
    output out  // Output signal out
);

// Direct NOR operation implementation using ~ (NOT) and | (OR) operators.
assign out = ~(a | b);

endmodule