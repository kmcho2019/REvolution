// Module TopModule implements an optimized XNOR gate
module TopModule(
    input logic a,  // Input signal a
    input logic b,  // Input signal b
    output logic out // Output signal out
);

// Use the XOR operator followed by negation for XNOR operation
assign out = ~(a ^ b);  // Output is 1 if inputs are the same, 0 otherwise

endmodule