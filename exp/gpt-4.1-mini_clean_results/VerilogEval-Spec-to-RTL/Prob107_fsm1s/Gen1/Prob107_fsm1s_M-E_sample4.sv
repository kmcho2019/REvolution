module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

    // State flip-flops: one-hot encoding
    reg state_A, state_B;
    reg next_state_A, next_state_B;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state_A <= 1'b0;
            state_B <= 1'b1;
        end else begin
            state_A <= next_state_A;
            state_B <= next_state_B;
        end
    end

    // Next state logic
    always @(*) begin
        // Default no state active (for safety)
        next_state_A = 1'b0;
        next_state_B = 1'b0;

        if (state_B) begin
            // From B state
            if (in == 1'b0) begin
                next_state_A = 1'b1;
            end else begin
                next_state_B = 1'b1;
            end
        end else if (state_A) begin
            // From A state
            if (in == 1'b0) begin
                next_state_B = 1'b1;
            end else begin
                next_state_A = 1'b1;
            end
        end else begin
            // If no state active (should not happen), go to B
            next_state_B = 1'b1;
        end
    end

    // Output logic (Moore): output=1 if in B, else 0
    always @(*) begin
        if (state_B)
            out = 1'b1;
        else
            out = 1'b0;
    end

endmodule