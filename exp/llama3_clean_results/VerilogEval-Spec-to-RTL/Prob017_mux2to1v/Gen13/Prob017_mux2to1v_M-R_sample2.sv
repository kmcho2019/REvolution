// Module TopModule implements a 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Use an always block to define the combinational logic for the multiplexer.
always @(*) begin
    // Determine the output 'out' based on the value of 'sel'.
    if (sel) begin
        out = b; // If 'sel' is 1, select 'b'.
    end else begin
        out = a; // If 'sel' is 0, select 'a'.
    end
end

// This implementation is functionally equivalent to the original but uses an always block.
endmodule