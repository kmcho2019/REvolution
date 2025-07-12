// Module TopModule implements an XNOR gate using a bitwise XOR operation and negation
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out // Output signal out
);

// Directly assign the XNOR operation result to the output using bitwise XOR and negation
assign out = ~(a ^ b);

endmodule