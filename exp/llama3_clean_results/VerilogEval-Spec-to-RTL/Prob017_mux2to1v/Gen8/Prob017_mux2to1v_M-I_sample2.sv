// Module TopModule implements a 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input             clk, // clock signal
    input             rst, // reset signal
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input       sel, // select line
    output [99:0] out // 100-bit output
);

// Use a flip-flop to register the output and reduce switching activity.
reg [99:0] out_reg;

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        out_reg <= '0;
    end else begin
        out_reg <= sel ? b : a;
    end
end

assign out = out_reg;

// The above lines directly implement the 2-1 multiplexer functionality.
// They conditionally assign 'out' to either 'a' or 'b' based on the value of 'sel'.

endmodule