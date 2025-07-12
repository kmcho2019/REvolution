// Module TopModule implements a 2-1 multiplexer using an always block.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Use an always block to implement the multiplexer
always @(*) begin
    case (sel)
        1'b0: out = a; // When sel is 0, select 'a'
        1'b1: out = b; // When sel is 1, select 'b'
        default: out = a; // Default case, select 'a'
    endcase
end

endmodule