// Module TopModule implements a 2-1 multiplexer design.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Directly select between 'a' and 'b' based on 'sel'
// This approach allows the synthesis tool to optimize the design effectively
assign out = sel? b : a;

// This design leverages the synthesis tool's optimization capabilities
// to minimize area and power consumption while maintaining performance

endmodule