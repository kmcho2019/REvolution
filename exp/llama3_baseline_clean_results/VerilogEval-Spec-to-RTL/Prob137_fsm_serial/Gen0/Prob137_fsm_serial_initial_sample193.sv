module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] state; // 0: Idle, 1: ReceiveBit, 2: VerifyStop
reg [2:0] bitCounter; // Counter for received bits
reg [7:0] data; // Received data

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // Reset to Idle state
        done <= 0;
        bitCounter <= 0;
    end else begin
        case (state)
            0: begin // Idle
                if (!in) begin // Start bit detected
                    state <= 1;
                    bitCounter <= 1;
                    data[0] <= 1'b1; // Least significant bit first
                end else begin
                    state <= 0;
                end
            end
            1: begin // ReceiveBit
                data[bitCounter] <= in; // Shift in the received bit
                bitCounter <= bitCounter + 1;
                if (bitCounter == 8) begin
                    state <= 2; // Transition to VerifyStop
                end
            end
            2: begin // VerifyStop
                if (in) begin // Stop bit detected
                    done <= 1; // Assert done for one clock cycle
                    state <= 0; // Transition back to Idle
                end else begin // Stop bit not detected, wait for stop bit
                    state <= 2;
                end
            end
            default: state <= 0;
        endcase
    end
end

always @(posedge clk) begin
    if (state == 0 && done) begin // Reset done after one clock cycle
        done <= 0;
    end
end

endmodule