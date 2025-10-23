module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 1-bit state variable

// Combinational logic for next state
always @(*) begin
    if (reset) begin
        out = 1'b1; // Output for state B
    end else if (~in && state) begin
        out = 1'b0; // Transitioning to state A
    end else if (~in && ~state) begin
        out = 1'b1; // Transitioning back to state B
    end else begin
        out = state ? 1'b1 : 1'b0; // Maintain current output based on state
    end
end

// Sequential logic for state update
always @(posedge clk) begin
    if (reset) begin
        state <= 1'b1; // Reset to state B
    end else if (~in && state) begin
        state <= 1'b0; // Update state to A
    end else if (~in && ~state) begin
        state <= 1'b1; // Update state back to B
    end
end

endmodule