// Module TopModule implements a 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Use an always block for the logic implementation.
// This approach provides more explicit control and might be optimized differently by synthesis tools.
always @(*) begin
    // When sel is 0, select input 'a'.
    if (!sel) begin
        out = a; // Select 'a' when sel is 0
    end
    // When sel is 1, select input 'b'.
    else begin
        out = b; // Select 'b' when sel is 1
    end
end

// Alternatively, a case statement could be used within the always block for a more explicit control structure:
// always @(*) begin
//     case (sel)
//         1'b0: out = a; // Select 'a' when sel is 0
//         1'b1: out = b; // Select 'b' when sel is 1
//     endcase
// end

// Note: The for loop approach can also be used for explicit control over the logic implementation.
// However, the always block with conditional statements or a case statement is more suitable for this design.

endmodule