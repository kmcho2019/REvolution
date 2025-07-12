// Module TopModule implements a 2-1 multiplexer using a generate block and for-loop.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Use a generate block with a for-loop to create the output bits of the multiplexer.
// For each bit, conditionally assign the output bit based on the 'sel' input.
genvar i;
generate
    for (i = 0; i < 100; i = i + 1) begin
        assign out[i] = sel? b[i] : a[i];
    end
endgenerate

endmodule