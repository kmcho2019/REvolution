// Module TopModule implements a 2-1 multiplexer using a case statement.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Use an always_comb block to handle the combinational logic.
always_comb begin
    case (sel)
        // When sel is 0, assign 'a' to 'out'.
        1'b0: out = a;
        // When sel is 1, assign 'b' to 'out'.
        1'b1: out = b;
        // Default case to handle any other value of 'sel' (should not occur).
        default: out = 'x; // Assign unknown value if 'sel' is not 0 or 1.
    endcase
end

endmodule