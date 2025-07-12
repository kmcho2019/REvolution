// Module TopModule implements an XNOR gate
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out // Output signal out
);

// Use the equality operator (==) to directly compare the inputs and implement the XNOR gate
assign out = (a == b);

endmodule