// Module TopModule implements a 2-1 multiplexer using bitwise operations.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Create a wire for the negation of 'sel' to be used in bitwise operations.
wire sel_neg;
assign sel_neg = ~sel;

// Use bitwise AND to mask 'a' and 'b' based on 'sel' and its negation.
// Then, use bitwise OR to combine the masked inputs into the final output.
assign out = (a & {100{sel_neg}}) | (b & {100{sel}});

endmodule