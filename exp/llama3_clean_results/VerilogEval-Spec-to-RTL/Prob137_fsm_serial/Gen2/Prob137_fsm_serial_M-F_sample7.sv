module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [7:0] data_register; // 8-bit register to collect data bits
reg [2:0] bit_count; // Counter to keep track of number of bits received
reg [1:0] state; // 2-bit register to represent the current state (IDLE, RECEIVE, STOP_WAIT)
reg start_bit; // Flag to indicate start bit detection

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to IDLE state
        data_register <= 8'b0; // Reset data register
        bit_count <= 3'b0; // Reset counter
        start_bit <= 1'b0; // Reset start bit detection flag
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 2'b01; // Transition to RECEIVE state
                    start_bit <= 1'b1; // Set start bit detection flag
                    data_register <= 8'b0; // Reset data register
                    bit_count <= 3'b1; // Increment counter
                end
            end
            2'b01: begin // RECEIVE state
                data_register <= {data_register[6:0], in}; // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
                if (bit_count == 9) begin // 9 bits received (start bit and 8 data bits)
                    if (in) begin // Stop bit correct
                        done <= 1'b1; // Set done signal high
                        state <= 2'b00; // Transition back to IDLE state
                    end else begin // Stop bit incorrect
                        state <= 2'b10; // Transition to STOP_WAIT state
                    end
                    bit_count <= 3'b0; // Reset counter
                end
            end
            2'b10: begin // STOP_WAIT state
                if (in) begin // Stop bit detected
                    state <= 2'b00; // Transition back to IDLE state
                end
            end
        endcase
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule