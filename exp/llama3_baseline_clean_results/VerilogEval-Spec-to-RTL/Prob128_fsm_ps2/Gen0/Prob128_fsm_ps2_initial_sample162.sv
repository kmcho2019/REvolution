module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

reg [1:0] state; // 0: IDLE, 1: BYTE1, 2: BYTE2, 3: DONE (not needed, handled separately)

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3] == 1) begin
                    state <= 1; // BYTE1
                end
            end
            1: begin // BYTE1
                state <= 2; // BYTE2
            end
            2: begin // BYTE2
                state <= 0; // IDLE
                done <= 1; // Signal DONE
            end
            default: state <= 0; // Should not happen
        endcase
    end
end

always @(posedge clk) begin
    if (~reset) begin
        if (state == 0) begin // IDLE
            done <= 0; // Clear DONE when not in DONE state
        end else if (state == 2) begin // BYTE2
            done <= 1; // Set DONE when in DONE state
        end else begin
            done <= 0; // Clear DONE when not in DONE state
        end
    end else begin
        done <= 0; // Clear DONE on reset
    end
end

endmodule