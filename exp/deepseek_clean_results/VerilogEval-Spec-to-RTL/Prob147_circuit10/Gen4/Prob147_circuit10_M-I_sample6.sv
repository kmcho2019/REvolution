module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;
wire next_state;

// Next state logic: toggle when both a and b are 1, else maintain state
assign next_state = (a & b) ? ~state_reg : state_reg;

// Output logic: q = (¬state & b) | (state & a)
assign q = (~state_reg & b) | (state_reg & a);

always @(posedge clk) begin
    state_reg <= next_state;
end

assign state = state_reg;

endmodule