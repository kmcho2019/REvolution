// Module TopModule implements a 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Use a single, vectorized assignment for the entire output.
// This approach is concise and potentially optimized more effectively by synthesis tools.
assign out = sel ? b : a;

// The above line directly implements the 2-1 multiplexer functionality.
// It conditionally assigns 'out' to either 'a' or 'b' based on the value of 'sel'.

endmodule