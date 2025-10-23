// Module TopModule implements an XNOR gate
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output reg out // Output signal out
);

// Use an always block to define the combinational logic for the XNOR operation
always @(*) begin
    // Compute the bitwise XOR of a and b, and then invert the result to get the XNOR operation
    out = ~(a ^ b);
end

endmodule