module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] state; // States for sequence matching: idle (0), matched_1 (1), matched_11 (2), matched_110 (3), matched_1101 (4)

always @ (posedge clk) begin
    if (reset) begin // Synchronous reset
        state <= 0; // Reset state machine to idle
        start_shifting <= 0; // Reset output
    end else begin
        case (state)
            0: begin // Idle state
                if (data) begin // Received first '1'
                    state <= 1;
                end else begin
                    state <= 0; // Stay in idle
                end
            end
            1: begin // Matched first '1'
                if (data) begin // Received second '1'
                    state <= 2;
                end else if (~data) begin // Received '0' after first '1'
                    state <= 0; // Reset to idle
                end else begin
                    state <= 1; // This condition should not be reachable
                end
            end
            2: begin // Matched '11'
                if (~data) begin // Received '0' after '11'
                    state <= 3;
                end else begin // Received another '1'
                    state <= 2; // Stay in matched '11'
                end
            end
            3: begin // Matched '110'
                if (data) begin // Received final '1'
                    state <= 4;
                end else begin
                    state <= 0; // Reset to idle
                end
            end
            4: begin // Matched '1101'
                start_shifting <= 1; // Set start_shifting to 1
                state <= 4; // Stay in final state
            end
            default: begin
                state <= 0; // Any other state, reset to idle
            end
        endcase
    end
end

// Ensure start_shifting is 0 when not in the final state
always @ (*) begin
    if (state == 4) begin
        start_shifting = 1;
    end else begin
        start_shifting = 0;
    end
end

endmodule