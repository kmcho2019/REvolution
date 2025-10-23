module TopModule(
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic q
);

// The original implementation is already optimized for its functionality
// Given the OR operation is the most straightforward way to implement the required logic,
// we focus on ensuring proper buffering or synchronization of inputs if needed in a larger context
assign q = b | c;

endmodule