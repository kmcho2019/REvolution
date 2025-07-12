// Module TopModule implements an XNOR gate using a simplified logic expression
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Directly assign the XNOR operation to the output
// Using the property that (a XNOR b) is equivalent to ~(a XOR b)
assign out = ~(a ^ b);

endmodule