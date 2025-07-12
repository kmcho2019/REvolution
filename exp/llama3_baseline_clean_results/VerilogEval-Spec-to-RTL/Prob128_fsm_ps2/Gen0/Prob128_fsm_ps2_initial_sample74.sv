module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // 0: IDLE, 1: BYTE1, 2: BYTE2, 3: DONE
reg [7:0] byte1, byte2; // Store the first two bytes of the message
reg done_reg; // Register to store the done signal

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3] == 1) begin
                    state <= 1; // Transition to BYTE1
                    byte1 <= in; // Store the first byte
                end
            end
            1: begin // BYTE1
                state <= 2; // Transition to BYTE2
                byte2 <= in; // Store the second byte
            end
            2: begin // BYTE2
                state <= 3; // Transition to DONE
            end
            3: begin // DONE
                done_reg <= 1; // Set done signal
                state <= 0; // Transition back to IDLE
            end
            default: state <= 0; // IDLE
        endcase
    end
end

always @(posedge clk) begin
    done <= done_reg;
    if (reset) done_reg <= 0;
end

endmodule