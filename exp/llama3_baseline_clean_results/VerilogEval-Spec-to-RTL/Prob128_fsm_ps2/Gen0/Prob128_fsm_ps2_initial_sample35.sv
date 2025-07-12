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
        done_reg <= 0; // Reset done signal
    end else begin
        case (state)
            0: begin // IDLE state
                if (in[3] == 1'b1) begin // Check if in[3] is 1
                    state <= 1; // Transition to BYTE1 state
                end
            end
            1: begin // BYTE1 state
                state <= 2; // Transition to BYTE2 state
            end
            2: begin // BYTE2 state
                state <= 3; // Transition to BYTE3 state
            end
            3: begin // BYTE3 state
                state <= 0; // Transition back to IDLE state
                done_reg <= 1'b1; // Signal done
            end
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        done <= 0; // Reset done signal
    end else begin
        if (state == 3) begin
            done <= done_reg; // Output done signal
            done_reg <= 0; // Clear done_reg for next cycle
        end else begin
            done <= 0; // Clear done signal
        end
    end
end

endmodule