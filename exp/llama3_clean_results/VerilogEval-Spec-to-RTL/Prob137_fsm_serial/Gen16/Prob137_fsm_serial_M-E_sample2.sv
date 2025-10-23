module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [3:0] state; // 4-bit ring counter
reg [7:0] data; // 8-bit data register
reg start_bit; // Start bit detector
reg stop_bit; // Stop bit verifier

always @(posedge clk) begin
    if (reset) begin
        state <= 4'b0001; // Reset to IDLE state
        data <= 8'b0; // Reset data register
        start_bit <= 1'b0; // Reset start bit detector
        stop_bit <= 1'b0; // Reset stop bit verifier
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            4'b0001: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 4'b0010; // Move to START state
                    start_bit <= 1'b1; // Set start bit detector
                end
            end
            4'b0010: begin // START state
                state <= 4'b0100; // Move to RECEIVE state
                data[0] <= in; // Load first data bit
            end
            4'b0100: begin // RECEIVE state
                data <= {data[6:0], in}; // Shift in new data bit
                if (data[7]) begin // 8 bits received
                    state <= 4'b1000; // Move to STOP state
                    stop_bit <= in; // Verify stop bit
                end
            end
            4'b1000: begin // STOP state
                if (stop_bit) begin // Stop bit correct
                    done <= 1'b1; // Set done signal high
                    state <= 4'b0001; // Move back to IDLE state
                end else begin // Stop bit incorrect
                    state <= 4'b0001; // Move back to IDLE state
                end
            end
        endcase
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule