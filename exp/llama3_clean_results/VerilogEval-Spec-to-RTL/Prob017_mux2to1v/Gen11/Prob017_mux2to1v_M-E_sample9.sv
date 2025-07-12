// Module TopModule implements a 2-1 multiplexer using vector operations.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Generate a mask based on 'sel' to conditionally select between 'a' and 'b'.
// The ternary operator is used to create a vector that is either all ones (when sel is 1)
// or all zeros (when sel is 0), which then conditionally selects 'b' or 'a' respectively.
assign out = (sel ? {100{1'b1}} : {100{1'b0}}) ? b : a;

// This approach uses bitwise operations and vector manipulation to achieve the multiplexing
// functionality, offering a concise and potentially efficient implementation.

endmodule