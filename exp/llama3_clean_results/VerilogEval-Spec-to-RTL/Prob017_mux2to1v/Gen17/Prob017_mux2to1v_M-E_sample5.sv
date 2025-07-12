// Module TopModule implements a 2-1 multiplexer using bitwise operations.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Create a mask based on the 'sel' signal.
// When 'sel' is 1, mask_b is all ones, and mask_a is all zeros.
// When 'sel' is 0, mask_b is all zeros, and mask_a is all ones.
wire [99:0] mask_b = {100{sel}};
wire [99:0] mask_a = ~mask_b;

// Use bitwise AND to mask 'a' and 'b' inputs based on 'sel'.
// Then, use bitwise OR to combine the masked 'a' and 'b' to produce 'out'.
assign out = (a & mask_a) | (b & mask_b);

endmodule