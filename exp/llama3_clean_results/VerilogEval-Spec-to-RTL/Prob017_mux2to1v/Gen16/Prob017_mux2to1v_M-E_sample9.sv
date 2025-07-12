// Module TopModule implements a novel 2-1 multiplexer architecture.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Use bitwise operations to conditionally select bits from 'a' or 'b'.
// The ~sel input is used to control the bitwise AND operation.
assign out = (~sel & a) | (sel & b);

endmodule