// Module TopModule implements a 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Calculate the bitwise AND of 'a' with the inverted 'sel' signal.
// Since 'sel' is a single bit, we need to replicate it to match the width of 'a'.
// We use the replication operator to create a 100-bit vector of the inverted 'sel' signal.
wire [99:0] a_and_not_sel = a & {100{~sel}};

// Calculate the bitwise AND of 'b' with the 'sel' signal.
// Similar to above, we replicate 'sel' to match the width of 'b'.
wire [99:0] b_and_sel = b & {100{sel}};

// Perform a bitwise OR operation between the two resulting values.
// This will correctly select either 'a' or 'b' based on the 'sel' signal.
// Alternatively, we could use a case statement or if-else for more explicit control.
assign out = a_and_not_sel | b_and_sel;

// Note: For more explicit control or potential optimization benefits:
// always @(*) begin
//     case (sel)
//         1'b0: out = a & {100{1'b1}} | b & {100{1'b0}};
//         1'b1: out = a & {100{1'b0}} | b & {100{1'b1}};
//     endcase
// end

// The vectorized assignment approach is more concise and potentially more efficient.
// assign out = sel ? b : a;

endmodule