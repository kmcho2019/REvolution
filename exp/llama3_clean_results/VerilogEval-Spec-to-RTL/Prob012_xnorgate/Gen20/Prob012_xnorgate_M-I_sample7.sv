// Module TopModule implements an XNOR gate using basic logic
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Alternative implementation using AND and OR gates
// This might be optimized differently by the synthesis tool
assign out = (a && b) || (!a && !b);

endmodule