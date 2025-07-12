// Module TopModule implements an XNOR gate
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Utilize the bitwise XOR operator (^) and invert the result to implement the XNOR gate
assign out = ~(a ^ b);

endmodule