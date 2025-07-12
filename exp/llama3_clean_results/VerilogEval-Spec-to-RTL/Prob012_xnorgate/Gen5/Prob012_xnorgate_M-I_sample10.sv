// Module TopModule implements an XNOR gate using a direct logical expression
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Directly compute the XNOR operation using a logical expression
assign out = ~(a ^ b);  // Output 1 when a and b are the same, 0 otherwise

endmodule