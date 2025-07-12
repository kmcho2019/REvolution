// Module TopModule implements a 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input wire [99:0] a,  // 100-bit input 'a'
    input wire [99:0] b,  // 100-bit input 'b'
    input wire sel,       // select line
    output wire [99:0] out // 100-bit output
);

// Directly use the ternary operator to select between 'a' and 'b' based on 'sel'.
// This implementation is already efficient but ensure proper handling of inputs.
assign out = sel ? b : a;

endmodule