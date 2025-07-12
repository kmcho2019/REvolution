// Module TopModule implements a 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// To potentially improve area and power efficiency, we use a for loop to generate the multiplexer logic for each bit.
// This approach allows for more fine-grained control over the generated logic, potentially leading to better optimization by the synthesis tool.

genvar i;
for (i = 0; i < 100; i++) begin
    assign out[i] = sel ? b[i] : a[i]; // Using the ternary operator within the loop for each bit
end

// Note: The vectorized assignment approach (assign out = sel? b : a;) is commented out in favor of the for loop,
// as it might provide better area and power optimization, but both methods are valid and the choice depends on the specific synthesis outcomes.

endmodule