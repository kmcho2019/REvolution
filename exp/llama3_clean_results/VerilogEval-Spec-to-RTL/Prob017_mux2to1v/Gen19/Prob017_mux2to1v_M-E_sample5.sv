// Novel Module TopModule implements a 2-1 multiplexer using bitwise operations.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Create a mask vector based on 'sel'. When 'sel' is 0, mask_a is all 1s and mask_b is all 0s.
// When 'sel' is 1, mask_a is all 0s and mask_b is all 1s.
wire [99:0] mask_a = {100{~sel}}; // ~sel because we want 1 when sel is 0
wire [99:0] mask_b = {100{sel}};

// Use bitwise AND to select bits from 'a' or 'b' based on the masks.
wire [99:0] and_a = a & mask_a;
wire [99:0] and_b = b & mask_b;

// Combine the results of the AND operations using a bitwise OR to produce the final output.
assign out = and_a | and_b;

endmodule