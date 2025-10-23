module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

    // One-hot encoding for states
    // state_b = 1 means in state B (reset state)
    // state_a = 1 means in state A
    reg state_b, state_a;
    reg next_state_b, next_state_a;

    // Synchronous reset sets to B
    always @(posedge clk) begin
        if (reset) begin
            state_b <= 1'b1;
            state_a <= 1'b0;
        end else begin
            state_b <= next_state_b;
            state_a <= next_state_a;
        end
    end

    // Next-state logic for one-hot FSM
    always @(*) begin
        // Default next states to 0 to avoid inferred latches
        next_state_b = 1'b0;
        next_state_a = 1'b0;

        if (state_b) begin
            if (in == 1'b0) begin
                next_state_a = 1'b1;
            end else begin
                next_state_b = 1'b1;
            end
        end else if (state_a) begin
            if (in == 1'b0) begin
                next_state_b = 1'b1;
            end else begin
                next_state_a = 1'b1;
            end
        end else begin
            // Defensive: if no state is active, reset to B
            next_state_b = 1'b1;
        end
    end

    // Output logic depends only on state B
    assign out = state_b;

endmodule