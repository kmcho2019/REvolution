// Optimized Module TopModule implements an XNOR gate
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out // Output signal out
);

// Use a logical expression that directly implements the XNOR gate
// This expression checks if both inputs are the same by using the equality operator
wire out_w = ~(a ^ b);
assign out = out_w;

endmodule