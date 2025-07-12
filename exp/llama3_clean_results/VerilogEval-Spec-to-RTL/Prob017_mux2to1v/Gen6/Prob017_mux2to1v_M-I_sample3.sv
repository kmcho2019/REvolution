// Module TopModule implements a 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Directly assign 'out' based on 'sel' using a ternary operator.
// This is a concise way to implement a 2-1 multiplexer and potentially more efficient for synthesis.
// The original implementation is already optimized for area and performance due to its simplicity.
// Further improvements would likely require adjustments to the surrounding logic or synthesis options.
assign out = sel? b : a;

endmodule