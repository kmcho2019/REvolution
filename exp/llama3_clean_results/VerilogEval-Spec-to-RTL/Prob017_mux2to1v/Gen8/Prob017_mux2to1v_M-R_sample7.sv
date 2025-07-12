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
// This approach is efficient and might be optimized more effectively by synthesis tools.
assign out = sel? b : a;

// Note: The for loop approach can also be used for explicit control over the logic implementation.
// However, the vectorized assignment is more concise and potentially more efficient.

endmodule