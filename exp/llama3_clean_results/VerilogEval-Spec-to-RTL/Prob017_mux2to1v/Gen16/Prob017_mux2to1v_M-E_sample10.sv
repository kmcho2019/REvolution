// Novel Module TopModule implements a vectorized 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Create a mask vector based on the 'sel' input.
// If 'sel' is 1, the mask will be all ones; otherwise, it will be all zeros.
wire [99:0] mask = {100{sel}};

// Use bitwise operations to select between 'a' and 'b' based on the mask.
assign out = (~mask & a) | (mask & b);

endmodule