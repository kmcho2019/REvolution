// Module TopModule implements a novel 2-1 multiplexer architecture.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Internal signals to facilitate the bitwise operations
wire [99:0] mask_a;
wire [99:0] mask_b;

// Generate masks based on the select signal
assign mask_a = {100{~sel}}; // When sel=0, mask_a is all ones; when sel=1, mask_a is all zeros
assign mask_b = {100{sel}};  // When sel=0, mask_b is all zeros; when sel=1, mask_b is all ones

// Use bitwise operations to implement the multiplexer
assign out = (a & mask_a) | (b & mask_b);

endmodule