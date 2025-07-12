// Module TopModule implements an XNOR gate using XOR and NOT operators
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Simplified assignment using XOR and NOT operators for XNOR
assign out = ~(a ^ b);

endmodule