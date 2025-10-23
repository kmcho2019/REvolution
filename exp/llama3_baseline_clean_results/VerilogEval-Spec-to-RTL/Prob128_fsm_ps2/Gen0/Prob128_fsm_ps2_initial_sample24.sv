module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output reg done
);

reg [1:0] state; // 2 bits to represent 4 states

always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to IDLE state
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3]) begin
                    state <= 2'b01; // Move to BYTE1 state
                end else begin
                    state <= 2'b00; // Stay in IDLE state
                end
                done <= 1'b0;
            end
            2'b01: begin // BYTE1 state
                state <= 2'b10; // Move to BYTE2 state
                done <= 1'b0;
            end
            2'b10: begin // BYTE2 state
                state <= 2'b11; // Move to BYTE3 state
                done <= 1'b0;
            end
            2'b11: begin // BYTE3 state
                if (in[3]) begin
                    state <= 2'b01; // New message starts, move to BYTE1 state
                end else begin
                    state <= 2'b11; // Stay in BYTE3 state, but signal done
                end
                done <= 1'b1;
            end
        endcase
    end
end

endmodule