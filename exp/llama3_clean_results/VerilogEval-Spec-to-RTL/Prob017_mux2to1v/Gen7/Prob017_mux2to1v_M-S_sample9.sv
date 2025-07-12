// Module TopModule implements a simplified 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Assign 'out' based on 'sel' using a ternary operator for simplicity.
assign out = sel ? b : a;

endmodule