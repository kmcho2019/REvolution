// Module TopModule implements an XNOR gate using bitwise XOR and NOT operations
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Compute the XNOR by inverting the result of the XOR operation
assign out = ~(a ^ b);

endmodule