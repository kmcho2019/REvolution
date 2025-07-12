module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;
wire next_state;

// Combinational logic for next state
assign next_state = (a & b) ? 1'b1 : 
                   (~a & ~b) ? 1'b0 : 
                   state_reg;

// State update on clock edge
always @(posedge clk) begin
    state_reg <= next_state;
end

// Output logic
assign q = a ^ b ^ state_reg;
assign state = state_reg;

endmodule