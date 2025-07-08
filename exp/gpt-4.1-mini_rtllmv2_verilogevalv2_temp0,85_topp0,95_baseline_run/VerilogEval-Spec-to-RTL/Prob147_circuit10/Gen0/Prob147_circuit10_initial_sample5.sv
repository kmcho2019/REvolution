module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire state_next;

// Compute next state based on current state and inputs
assign state_next = (a & ~state) | (b & ~a & state);

// Output q equals the next state
assign q = state_next;

// Flip-flop updates state on rising edge of clock
always @(posedge clk) begin
    state <= state_next;
end

endmodule