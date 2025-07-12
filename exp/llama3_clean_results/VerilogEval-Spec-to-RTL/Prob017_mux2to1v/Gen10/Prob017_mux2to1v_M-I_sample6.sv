// Module TopModule implements a 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Using a for loop to generate the multiplexer logic for each bit.
// This approach may lead to better area and power optimization.
genvar i;
for (i = 0; i < 100; i++) begin
    assign out[i] = sel ? b[i] : a[i];
end

// Alternatively, a single, vectorized assignment can also be used:
// assign out = sel ? b : a;

endmodule