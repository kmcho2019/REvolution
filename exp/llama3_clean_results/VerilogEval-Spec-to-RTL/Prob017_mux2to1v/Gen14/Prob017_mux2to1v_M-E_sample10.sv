// Module TopModule implements a 2-1 multiplexer using a decoder and tri-state buffers.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Create a decoder to generate the enable signals for the tri-state buffers.
// The decoder will have two outputs: one for selecting 'a' and one for selecting 'b'.
wire a_enable, b_enable;
assign a_enable = ~sel;
assign b_enable = sel;

// Generate the tri-state buffers for each bit of the inputs.
genvar i;
for (i = 0; i < 100; i++) begin
    // Use a tri-state buffer to select between the corresponding bits of 'a' and 'b'.
    // When the enable signal is high, the buffer will drive the output with the selected bit.
    assign out[i] = a_enable ? a[i] : (b_enable ? b[i] : 1'bz);
end

endmodule