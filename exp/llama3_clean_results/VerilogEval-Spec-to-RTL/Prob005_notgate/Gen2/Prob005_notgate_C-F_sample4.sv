// Superior solution with clarity, conciseness, and best practices
module TopModule(
    input  logic in,  // Input signal
    output logic out   // Output signal, inverted version of input
);

// Direct assignment is used for clarity and efficiency
// The logical NOT operator (~) inverts the input signal
assign out = ~in;  // Invert input signal and assign to output

endmodule