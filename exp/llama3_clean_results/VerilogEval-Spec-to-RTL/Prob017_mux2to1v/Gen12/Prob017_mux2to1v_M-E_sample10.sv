// Module TopModule implements a 2-1 multiplexer using bitwise AND and OR operations.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Compute the bitwise AND of 'sel' and 'b'.
wire [99:0] sel_b;
assign sel_b = {100{sel}} & b;

// Compute the bitwise AND of the inverse of 'sel' and 'a'.
wire [99:0] sel_not_a;
assign sel_not_a = {100{~sel}} & a;

// Compute the bitwise OR of the results to produce the final output 'out'.
assign out = sel_b | sel_not_a;

endmodule