// Module TopModule implements an XNOR gate using equality comparison
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Assign output directly using equality comparison
// This implementation uses the equality operator (==) to compare inputs and output 1 if they are the same
assign out = (a == b) ? 1'b1 : 1'b0;

endmodule