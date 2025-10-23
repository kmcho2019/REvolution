// Module TopModule implements a 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Use an always block for more explicit control over the logic implementation.
always @(*) begin
    // Conditionally assign either input 'a' or 'b' to the output 'out' based on the 'sel' input.
    out = sel? b : a;
end

// Note: The vectorized assignment approach can also be used for conciseness and potential efficiency.
// However, the always block provides more flexibility and control over the implementation.

endmodule