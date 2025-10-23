module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

wire next_state;
reg state_reg = 0;

// State update using continuous assignment
assign next_state = (a & b) ? ~state_reg : state_reg;

// Clocked state update
always @(posedge clk) begin
    state_reg <= next_state;
end

// Output logic using continuous assignments
assign q = (state_reg & ~b) | (~state_reg & a & b);
assign state = state_reg;

endmodule