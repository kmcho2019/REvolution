// Module TopModule implements an XNOR gate
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Use the XOR operator followed by negation to implement the XNOR gate
// This expression outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
assign out = ~(a ^ b);

endmodule