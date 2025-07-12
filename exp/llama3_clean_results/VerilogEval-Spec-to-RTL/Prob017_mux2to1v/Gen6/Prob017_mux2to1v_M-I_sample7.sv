// Module TopModule implements a 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input wire [99:0] a,  // 100-bit input 'a'
    input wire [99:0] b,  // 100-bit input 'b'
    input wire sel,       // select line
    output reg [99:0] out // 100-bit output
);

// Use an always block with a conditional statement to select between 'a' and 'b' based on 'sel'.
// This implementation is functionally equivalent to the ternary operator but may allow for different synthesis outcomes.
always @(*) begin
    if (sel) begin
        out = b;
    end else begin
        out = a;
    end
end

endmodule