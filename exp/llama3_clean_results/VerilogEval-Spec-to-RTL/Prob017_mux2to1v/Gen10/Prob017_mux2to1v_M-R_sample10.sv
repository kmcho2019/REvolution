// Module TopModule implements a 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Use a combinational always block with a case statement to implement the multiplexer.
always @(*) begin
    case (sel)
        1'b0: out = a; // When sel is 0, select 'a'.
        1'b1: out = b; // When sel is 1, select 'b'.
        default: out = 100'b0; // Default case, assign all zeros to 'out'.
    endcase
end

// This implementation demonstrates an alternative structural approach to the 2-1 multiplexer functionality.

endmodule