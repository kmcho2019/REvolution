module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // Single flip-flop for OFF (0) and ON (1) states
reg next_state; // Intermediate variable for state transition logic

// State transition logic
always_comb begin
    case (state)
        1'b0: next_state = j; // Transition to ON if j is 1, otherwise stay in OFF
        1'b1: next_state = ~k; // Stay in ON state if k is 0, otherwise transition to OFF
    endcase
end

// Synchronous state update and output logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
        out <= 1'b0; // Reset output to 0
    end else begin
        state <= next_state; // Update state based on next_state calculation
        out <= next_state; // Update output based on next state
    end
end

endmodule