module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

reg [1:0] state; // 0: IDLE, 1: S1, 2: S2, 3: S3, others: unused
assign start_shifting = (state == 3); // start_shifting is 1 when in FOUND state

always @(posedge clk) begin
    if (reset) begin // Reset is active high
        state <= 0; // Go back to IDLE state on reset
    end else begin
        case (state)
            0: begin // IDLE state
                if (data == 1) begin
                    state <= 1; // Transition to S1 if data is 1
                end else begin
                    state <= 0; // Stay in IDLE if data is 0
                end
            end
            1: begin // S1 state
                if (data == 1) begin
                    state <= 2; // Transition to S2 if data is 1
                end else if (data == 0) begin
                    state <= 3; // Transition to S3 if data is 0 (sequence 11 -> 110)
                end else begin
                    state <= 1; // Stay in S1, this line should not be reachable
                end
            end
            2: begin // S2 state
                if (data == 0) begin
                    state <= 3; // Transition to S3 if data is 0
                end else begin
                    state <= 1; // Reset to S1 if data is 1 (start over)
                end
            end
            3: begin // FOUND state
                state <= 3; // Stay in FOUND state
            end
            default: begin // Unused states, should not be reachable
                state <= 0; // Return to IDLE for safety
            end
        endcase
    end
end

endmodule