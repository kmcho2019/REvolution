module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;
wire next_state;

// Combinational next state logic
assign next_state = (a & b) ? 1'b1 : 
                   (~a & ~b) ? 1'b0 : 
                   state_reg;

// Sequential state update
always @(posedge clk) begin
    state_reg <= next_state;
end

// Output logic remains the same
assign q = a ^ b ^ state_reg;
assign state = state_reg;

endmodule