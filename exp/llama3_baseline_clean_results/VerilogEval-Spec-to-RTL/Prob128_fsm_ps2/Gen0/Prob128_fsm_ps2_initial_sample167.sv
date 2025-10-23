module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

reg [1:0] state; // 00: IDLE, 01: BYTE1, 10: BYTE2, 11: BYTE3

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to IDLE state
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3] == 1'b1) begin
                    state <= 2'b01; // Transition to BYTE1 state
                end
                done <= 1'b0;
            end
            2'b01: begin // BYTE1 state
                state <= 2'b10; // Transition to BYTE2 state
                done <= 1'b0;
            end
            2'b10: begin // BYTE2 state
                state <= 2'b11; // Transition to BYTE3 state
                done <= 1'b0;
            end
            2'b11: begin // BYTE3 state
                done <= 1'b1; // Signal done
                if (in[3] == 1'b1) begin
                    state <= 2'b01; // Transition to BYTE1 state
                end else begin
                    state <= 2'b00; // Transition to IDLE state
                end
            end
        endcase
    end
end

endmodule