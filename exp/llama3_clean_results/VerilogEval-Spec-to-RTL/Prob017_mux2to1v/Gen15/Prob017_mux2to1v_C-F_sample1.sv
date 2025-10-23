// Superior Module TopModule implements a 2-1 multiplexer.
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

// Use a for loop to generate the multiplexer logic for each bit.
// Within the loop, use bitwise operations to select between 'a' and 'b' based on the control vector.
genvar i;
for (i = 0; i < 100; i++) begin
    // Assign each bit of the output based on the control vector.
    assign out[i] = control_vector[i]? b[i] : a[i];
end

endmodule