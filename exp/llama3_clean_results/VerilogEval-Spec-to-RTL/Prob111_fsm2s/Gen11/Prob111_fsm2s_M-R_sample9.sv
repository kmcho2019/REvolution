module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // Single flip-flop for OFF (0) and ON (1) states

// Next state logic using combinational logic
reg next_state;
assign next_state = (state == 1'b0)? j : (state == 1'b1)? ~k : 1'b0;

// State register with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        state <= next_state; // Update state based on next state logic
    end
end

// Output logic based on current state
always_comb begin
    out = state; // Directly assign state to output
end

endmodule