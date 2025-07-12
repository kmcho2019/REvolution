// Module TopModule implements an XNOR gate using basic logic
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Assign output directly using XNOR operation
// This implementation is already efficient, and we ensure it's optimized by the synthesis tool
assign out = ~(a ^ b);  // XNOR operation: output is 1 if inputs are the same

// Alternatively, we can use synthesis attributes to guide optimization
// For example, to optimize for area:
// (* area_opt *) assign out = ~(a ^ b);

// Or to optimize for power:
// (* power_opt *) assign out = ~(a ^ b);

endmodule