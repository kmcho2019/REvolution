// Module TopModule implements an XNOR gate using a logical expression with bitwise XOR
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Continuous assignment with a logical expression for XNOR using bitwise XOR
assign out = ~(a ^ b);

endmodule