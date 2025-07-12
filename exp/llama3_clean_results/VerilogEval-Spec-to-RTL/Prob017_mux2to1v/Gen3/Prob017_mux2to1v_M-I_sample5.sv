// Module TopModule implements a 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Use a for loop to generate the multiplexer logic for each bit.
// This approach allows for explicit control over the logic implementation,
// potentially leading to better area and power optimization by the synthesis tool.
genvar i;
for (i = 0; i < 100; i++) begin
    assign out[i] = sel ? b[i] : a[i];
end

endmodule