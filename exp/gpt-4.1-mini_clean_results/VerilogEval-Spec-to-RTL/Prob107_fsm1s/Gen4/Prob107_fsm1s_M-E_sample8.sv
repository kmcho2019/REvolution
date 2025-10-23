module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

    reg state_A, state_B; // One-hot encoded states

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state_B <= 1'b1;
            state_A <= 1'b0;
        end else begin
            // Transition logic
            if (state_B) begin
                if (in == 1'b0) begin
                    state_A <= 1'b1;
                    state_B <= 1'b0;
                end else begin
                    state_A <= 1'b0;
                    state_B <= 1'b1;
                end
            end else begin // state_A
                if (in == 1'b0) begin
                    state_A <= 1'b0;
                    state_B <= 1'b1;
                end else begin
                    state_A <= 1'b1;
                    state_B <= 1'b0;
                end
            end
        end
    end

    // Output logic: out=1 when in state_B, else 0
    always @(*) begin
        out = state_B;
    end

endmodule