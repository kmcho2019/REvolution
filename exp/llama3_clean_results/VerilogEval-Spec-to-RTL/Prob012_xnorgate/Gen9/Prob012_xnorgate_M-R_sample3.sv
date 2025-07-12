// Module TopModule implements an XNOR gate using the equality operator
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Directly implement XNOR using the equality operator
assign out = ~(a ^ b); // XNOR is equivalent to NOT(XOR)

endmodule