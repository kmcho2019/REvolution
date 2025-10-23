module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;
reg prev_a, prev_b;

// Edge detectors
wire a_posedge = a && !prev_a;
wire b_posedge = b && !prev_b;

// Next state logic
wire state_transition = (state_reg && a_posedge) || (!state_reg && b_posedge);
wire next_state = state_transition ? ~state_reg : state_reg;

// Output is high during state transitions
assign q = state_transition;

always @(posedge clk) begin
    state_reg <= next_state;
    prev_a <= a;
    prev_b <= b;
end

assign state = state_reg;

endmodule