// Module TopModule implements a 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Use an if-else statement for explicit control.
always @(*) begin
    if (sel == 1'b0) begin
        out = a;
    end else begin
        out = b;
    end
end

// Alternatively, for a more concise version of the above:
// always @(*) begin
//     out = (sel == 1'b0) ? a : b;
// end

// Or, using a case statement for more explicit control over the selection logic:
// always @(*) begin
//     case (sel)
//         1'b0: out = a;
//         1'b1: out = b;
//     endcase
// end

// Note: The original vectorized assignment is still a viable and efficient option.
// assign out = sel ? b : a;

endmodule