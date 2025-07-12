module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

    // One-hot state encoding
    reg state_B, state_A;
    reg next_state_B, next_state_A;

    // Sequential logic with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state_B <= 1'b1;  // Reset state is B
            state_A <= 1'b0;
        end else begin
            state_B <= next_state_B;
            state_A <= next_state_A;
        end
    end

    // Next-state and output logic
    always @(*) begin
        // Default assignments
        next_state_B = 1'b0;
        next_state_A = 1'b0;
        out = 1'b0;

        if (state_B) begin
            out = 1'b1;
            if (in == 1'b0) begin
                next_state_A = 1'b1;
            end else begin
                next_state_B = 1'b1;
            end
        end else if (state_A) begin
            out = 1'b0;
            if (in == 1'b0) begin
                next_state_B = 1'b1;
            end else begin
                next_state_A = 1'b1;
            end
        end else begin
            // In case of invalid state, go to reset state B
            next_state_B = 1'b1;
            out = 1'b1;
        end
    end

endmodule