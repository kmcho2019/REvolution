// Superior Module TopModule implements a 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Internal signals to facilitate the bitwise operations
wire [99:0] mask_a;
wire [99:0] mask_b;

// Generate masks based on the select signal
assign mask_a = {100{~sel}}; // When sel=0, mask_a is all ones; when sel=1, mask_a is all zeros
assign mask_b = {100{sel}};  // When sel=0, mask_b is all zeros; when sel=1, mask_b is all ones

// Use a for loop to generate the multiplexer logic for each bit
genvar i;
for (i = 0; i < 100; i++) begin
    // Assign each bit of the output based on the select line and bitwise operations
    assign out[i] = (a[i] & mask_a[i]) | (b[i] & mask_b[i]);
end

endmodule