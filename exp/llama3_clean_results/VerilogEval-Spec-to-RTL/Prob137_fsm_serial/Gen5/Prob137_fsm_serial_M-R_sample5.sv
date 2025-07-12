module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] state; // 3-bit state register
reg [7:0] data; // 8-bit register to collect incoming data bits
reg [2:0] bit_count; // 3-bit counter to keep track of number of bits received
reg start_bit; // Flag to indicate start bit detection
reg stop_bit; // Flag to indicate stop bit detection

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset state
        data <= 8'b0; // Reset data register
        bit_count <= 3'b0; // Reset counter
        start_bit <= 1'b0; // Reset start bit detection flag
        stop_bit <= 1'b0; // Reset stop bit detection flag
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            0: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 1; // Transition to RECEIVE state
                    start_bit <= 1'b1; // Set start bit detection flag
                    bit_count <= 3'b1; // Increment counter
                    data <= {7'b0, in}; // Load start bit into data register
                end
            end
            1: begin // RECEIVE state
                data <= {data[6:0], in}; // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
                if (bit_count == 3'b100) begin // 9 bits received
                    if (in) begin // Stop bit correct
                        stop_bit <= 1'b1; // Set stop bit detection flag
                        state <= 2; // Transition to DONE state
                    end else begin // Stop bit incorrect, wait for stop bit
                        state <= 0; // Transition to IDLE state
                    end
                end
            end
            2: begin // DONE state
                done <= 1'b1; // Set done signal high
                state <= 0; // Transition to IDLE state
            end
        endcase
        if (state == 2) begin
            start_bit <= 1'b0; // Reset start bit detection flag
            stop_bit <= 1'b0; // Reset stop bit detection flag
            bit_count <= 3'b0; // Reset counter
        end
    end
end

always @(posedge clk) begin
    if (state == 2) begin
        done <= 1'b0; // Reset done signal
    end
end

endmodule