// Module TopModule implements a 2-1 multiplexer using bitwise operations.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Compute a mask based on 'sel'. When 'sel' is 0, the mask is all zeros; when 'sel' is 1, the mask is all ones.
wire [99:0] mask = {100{sel}};

// Use bitwise operations to select between 'a' and 'b' based on 'sel'.
// When 'sel' is 0, 'out' = 'a'; when 'sel' is 1, 'out' = 'b'.
assign out = (a & ~mask) | (b & mask);

// PPA Considerations:
// - Performance (Timing): This implementation may have different timing characteristics compared to the ternary operator or for loop approach. Evaluate and optimize as necessary.
// - Power: Consider minimizing switching activity on inputs 'a' and 'b' to reduce power consumption.
// - Area: This implementation may result in different area usage compared to other approaches. Explore optimization techniques as needed.

endmodule