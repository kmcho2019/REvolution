// Module TopModule implements a 2-1 multiplexer using bitwise operations and a control vector.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Create a control vector based on the 'sel' input.
// If 'sel' is 0, the control vector is all zeros, selecting 'a'.
// If 'sel' is 1, the control vector is all ones, selecting 'b'.
wire [99:0] control_vector = {100{sel}};

// Use bitwise operations to select between 'a' and 'b' based on the control vector.
// For each bit, if the control bit is 0, select the corresponding bit from 'a', otherwise select from 'b'.
assign out = (~control_vector & a) | (control_vector & b);

endmodule