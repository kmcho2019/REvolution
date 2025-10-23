module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;
wire next_state;

// Next state logic:
// Set when (~a & b)
// Reset when (a & ~b)
// Toggle when (a & b)
assign next_state = (~a & b) ? 1'b1 :
                   (a & ~b) ? 1'b0 :
                   (a & b) ? ~state_reg :
                   state_reg;

// Output logic:
// q = (b & ~state) | (~b & state) | (a & b)
assign q = (b ^ state_reg) | (a & b);

always @(posedge clk) begin
    state_reg <= next_state;
end

assign state = state_reg;

endmodule