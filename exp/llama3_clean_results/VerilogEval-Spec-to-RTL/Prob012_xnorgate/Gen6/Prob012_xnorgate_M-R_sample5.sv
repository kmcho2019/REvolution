// Module TopModule implements an XNOR gate using an always block
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output reg out // Output signal out, declared as reg for use within always block
);

// Use an always block to compute the XNOR operation
always @(*) begin
    // Compute the XNOR result using a procedural assignment
    out = ~(a ^ b);  // Output 1 when a and b are the same, 0 otherwise
end

endmodule