// Module TopModule implements a 2-1 multiplexer using a case statement for input selection.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Use an always block to handle the combinational logic.
// Within the block, a case statement is used to select between 'a' and 'b' based on 'sel'.
always @(*) begin
    case (sel)
        1'b0: out = a; // When 'sel' is 0, select 'a'
        1'b1: out = b; // When 'sel' is 1, select 'b'
        default: out = 100'b0; // Default case, set 'out' to all zeros
    endcase
end

endmodule