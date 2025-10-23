// Module TopModule implements an XNOR gate
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Use a simple logical expression to compute the XNOR operation
assign out = ~(a ^ b);  // XNOR: output 1 when a and b are the same, output 0 otherwise

endmodule