// Module TopModule implements an optimized 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Generate a control vector based on the 'sel' input.
// This approach allows the synthesizer to optimize the logic.
wire [99:0] control_vector = {100{sel}};

// Use bitwise operations to conditionally select bits from 'a' or 'b'.
// This construct is synthesizable and should be optimized by the synthesis tool.
assign out = (sel)? b : a;

endmodule