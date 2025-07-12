module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

wire next_state;
reg state_reg = 0;

// Next state logic (toggles when a=1 and b=1)
assign next_state = (a & b) ? ~state_reg : state_reg;

// Flip-flop implementation using clocked assignment
always @(posedge clk) begin
    state_reg <= next_state;
end

// Output logic
assign q = a ? (state_reg ^ ~b) : b;
assign state = state_reg;

endmodule