// Module TopModule implements a 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// We use an always block with combinational logic to implement the multiplexer.
// The 'always @*' syntax ensures the block is re-evaluated whenever any of the inputs change.
always @* begin
    // We use a case statement to handle the selection logic, providing an alternative to the ternary operator.
    case (sel)
        1'b0: out = a; // If sel is 0, select 'a'
        1'b1: out = b; // If sel is 1, select 'b'
        default: out = a; // Default case, select 'a' if sel is not 0 or 1
    endcase
end

// Alternatively, we could have used a for loop within the always block to assign each bit of 'out' individually.
// This approach can be useful for readability and potentially for synthesis optimization.
// genvar i;
// always @* begin
//     for (i = 0; i < 100; i++) begin
//         case (sel)
//             1'b0: out[i] = a[i]; // If sel is 0, select bit 'i' from 'a'
//             1'b1: out[i] = b[i]; // If sel is 1, select bit 'i' from 'b'
//             default: out[i] = a[i]; // Default case, select bit 'i' from 'a' if sel is not 0 or 1
//         endcase
//     end
// end

endmodule