// Superior Module TopModule implements an XNOR gate
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out // Output signal out
);

// Use a logical expression that directly implements the XNOR gate
// This expression checks if both inputs are the same by using the equality implied by the XOR and NOT operators
assign out = ~(a ^ b);  // Directly assign the output using the optimized XNOR expression

endmodule