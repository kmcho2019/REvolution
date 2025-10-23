module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // 0: IDLE, 1: BYTE1, 2: BYTE2, 3: BYTE3
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to IDLE state
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (in[3] == 1) begin
                    state <= 1; // Transition to BYTE1 state
                end else begin
                    state <= 0; // Stay in IDLE
                end
            end
            1: begin // BYTE1 state
                state <= 2; // Transition to BYTE2 state
            end
            2: begin // BYTE2 state
                state <= 3; // Transition to BYTE3 state
            end
            3: begin // BYTE3 state
                done_reg <= 1; // Signal done
                state <= 0; // Reset to IDLE state
            end
            default:
                state <= 0; // Default to IDLE state
        endcase
    end
end

assign done = done_reg;

always @(posedge clk) begin
    if (!reset) begin
        done_reg <= 0; // Reset done signal on next clock cycle
    end
end

endmodule