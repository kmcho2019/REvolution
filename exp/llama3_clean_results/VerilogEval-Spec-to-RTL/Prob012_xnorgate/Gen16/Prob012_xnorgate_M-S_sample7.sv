// Module TopModule implements an XNOR gate using the equality operator
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Directly assign the result of the equality check to the output
assign out = (a == b)? 1'b1 : 1'b0;

endmodule