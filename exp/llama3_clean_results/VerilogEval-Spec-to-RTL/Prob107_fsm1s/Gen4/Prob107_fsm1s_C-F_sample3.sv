module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 1-bit variable to hold the state (0 for A, 1 for B)

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1'b1; // Reset to state B
    end else begin
        if (state == 1'b1) begin // Current state is B
            if (in == 1'b0) begin
                state <= 1'b0; // Transition to state A
            end else begin
                state <= 1'b1; // Stay in state B
            end
        end else begin // Current state is A
            if (in == 1'b0) begin
                state <= 1'b1; // Transition to state B
            end else begin
                state <= 1'b0; // Stay in state A
            end
        end
    end
    // Directly assign the output based on the state
    out <= state;
end

endmodule