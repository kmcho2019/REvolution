// Refactored Module TopModule implements a 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Approach 1: Using always block with case statement
always @(*) begin
    case (sel)
        1'b0: out = a;
        1'b1: out = b;
        default: out = 100'b0; // Optional default case
    endcase
end

// Approach 2: Using ternary operator within assign statement (Alternative)
// assign out = sel ? b : a;

// Approach 3: Single assign statement with conditional operator (Alternative)
// This is the most concise version and likely to be the most efficient after synthesis.
// assign out = (sel) ? b : a;

endmodule