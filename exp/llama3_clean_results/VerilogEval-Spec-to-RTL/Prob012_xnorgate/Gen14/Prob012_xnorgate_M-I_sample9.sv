// Module TopModule implements an XNOR gate using NOT(XOR) operation
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Directly implement XNOR using NOT(XOR) operation
assign out = ~(a ^ b);  // Output is 1 if both inputs are the same

endmodule