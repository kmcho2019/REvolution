module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

    // One-hot state registers
    reg state_B, state_A;
    reg next_state_B, next_state_A;

    // Synchronous active-high reset and state update
    always @(posedge clk) begin
        if (reset) begin
            state_B <= 1'b1; // reset state B
            state_A <= 1'b0;
        end else begin
            state_B <= next_state_B;
            state_A <= next_state_A;
        end
    end

    // Next state logic using one-hot encoding
    always @(*) begin
        // Default assignments to avoid latches
        next_state_B = 1'b0;
        next_state_A = 1'b0;

        if (state_B) begin
            if (in == 1'b0) begin
                next_state_B = 1'b0;
                next_state_A = 1'b1;
            end else begin
                next_state_B = 1'b1;
                next_state_A = 1'b0;
            end
        end else if (state_A) begin
            if (in == 1'b0) begin
                next_state_B = 1'b1;
                next_state_A = 1'b0;
            end else begin
                next_state_B = 1'b0;
                next_state_A = 1'b1;
            end
        end else begin
            // In case both states are zero (should not happen), reset to B
            next_state_B = 1'b1;
            next_state_A = 1'b0;
        end
    end

    // Output depends only on state_B being high (Moore output)
    assign out = state_B;

endmodule