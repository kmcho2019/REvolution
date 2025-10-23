// Module TopModule implements an XNOR gate using a continuous assignment with a logical expression
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Continuous assignment with a logical expression for XNOR
assign out = (a == b) ? 1'b1 : 1'b0;

endmodule