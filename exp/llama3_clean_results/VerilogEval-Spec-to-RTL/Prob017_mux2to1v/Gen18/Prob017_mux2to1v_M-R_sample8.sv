// Module TopModule implements a 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Use an always block to assign the output based on the select line.
// This approach is an alternative to the continuous assignment.
always @(*) begin
    // Use the ternary operator to select between 'a' and 'b' based on 'sel'.
    // This line is functionally equivalent to the assign statement in the original code.
    out = sel? b : a;
end

endmodule