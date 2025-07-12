// Module TopModule implements an XNOR gate using the bitwise XOR operator and inversion
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Continuous assignment using bitwise XOR and inversion for XNOR
assign out = ~(a ^ b);

endmodule