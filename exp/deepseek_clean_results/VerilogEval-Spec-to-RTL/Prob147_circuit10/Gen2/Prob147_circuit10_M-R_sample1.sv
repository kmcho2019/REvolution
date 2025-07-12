module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;  // Initialize to 0
wire next_state;

// Next state is toggled only when both a and b are 1
assign next_state = (a & b) ? ~state_reg : state_reg;

// Output q is state when a=1, otherwise follows b
assign q = a ? state_reg : b;
assign state = state_reg;

always @(posedge clk) begin
    state_reg <= next_state;
end

endmodule