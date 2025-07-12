// Module TopModule implements an XNOR gate using AND and OR gates
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Implement XNOR using AND and OR gates
// (a AND b) OR (NOT a AND NOT b) equals 1 if a and b are the same
assign out = (a && b) || (!a && !b);

endmodule