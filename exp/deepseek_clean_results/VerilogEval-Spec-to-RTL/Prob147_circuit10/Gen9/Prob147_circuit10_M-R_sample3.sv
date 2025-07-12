module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

wire d_ff;
reg state_ff = 0;

// Flip-flop implementation using clocked assignment
always @(posedge clk) begin
    state_ff <= d_ff;
end

// Next state logic (toggles when both a and b are high)
assign d_ff = (a & b) ? ~state_ff : state_ff;

// Output logic (pass-through b when a=0, output state when a=1)
assign q = a ? state_ff : b;
assign state = state_ff;

endmodule