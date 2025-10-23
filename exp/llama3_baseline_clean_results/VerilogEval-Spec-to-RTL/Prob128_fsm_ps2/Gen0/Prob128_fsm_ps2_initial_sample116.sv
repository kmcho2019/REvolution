module TopModule (
    input  clk,
    input  reset,
    input  [7:0] in,
    output done
);

reg [1:0] state; // IDLE (2'b00), BYTE1 (2'b01), BYTE2 (2'b10), BYTE3 (2'b11)
reg [7:0] byte1, byte2, byte3;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to IDLE state
        byte1 <= 8'b0;
        byte2 <= 8'b0;
        byte3 <= 8'b0;
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3]) begin
                    state <= 2'b01; // Transition to BYTE1 state
                    byte1 <= in; // Store the first byte
                end
            end
            2'b01: begin // BYTE1 state
                state <= 2'b10; // Transition to BYTE2 state
                byte2 <= in; // Store the second byte
            end
            2'b10: begin // BYTE2 state
                state <= 2'b11; // Transition to BYTE3 state
                byte3 <= in; // Store the third byte
            end
            2'b11: begin // BYTE3 state
                done <= 1'b1; // Signal done
                state <= 2'b00; // Transition back to IDLE state
                if (in[3]) begin
                    state <= 2'b01; // If next byte has in[3]=1, start a new message
                    byte1 <= in; // Store the new first byte
                end
            end
        endcase
    end
end

endmodule