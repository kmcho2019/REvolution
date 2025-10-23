// Module TopModule implements a 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

reg [99:0] temp_out; // Intermediate variable for output

always @(*) begin
    case(sel)
        1'b0: temp_out = a; // When sel is 0, choose a
        1'b1: temp_out = b; // When sel is 1, choose b
        default: temp_out = 'bx; // For any other value, set output to unknown (this should not occur in this context)
    endcase
end

assign out = temp_out; // Assign the intermediate result to the output

endmodule