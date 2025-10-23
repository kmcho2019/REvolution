// Module TopModule implements an XNOR gate
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output reg out // Output signal out
);

// Use a combinational always block to implement the XNOR gate
always @(*) begin
    // Implement the XNOR logic as a comparison of the two inputs being equal
    out = (a == b);
end

endmodule