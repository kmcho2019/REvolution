// Module TopModule implements a 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Use an always block and a case statement to conditionally assign 'out' based on 'sel'.
// This approach allows for easy extension to more complex scenarios and provides clear logic flow.
always @(a, b, sel) begin
    case (sel)
        1'b0: out = a; // Select 'a' when sel is 0
        1'b1: out = b; // Select 'b' when sel is 1
        default: out = 100'b0; // Default case, assign output to zero for any other value of sel
    endcase
end

endmodule