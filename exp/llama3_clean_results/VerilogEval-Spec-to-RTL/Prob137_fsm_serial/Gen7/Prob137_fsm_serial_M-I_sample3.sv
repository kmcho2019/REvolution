module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [7:0] data_register; // 8-bit register to store incoming data bits
reg [3:0] bit_count; // 4-bit counter to track number of bits received
reg start_bit_detected; // Flag to indicate start bit detection
reg stop_bit_expected; // Flag to indicate stop bit expectation

always @(posedge clk) begin
    if (reset) begin
        data_register <= 8'b0; // Reset data register
        bit_count <= 4'b0; // Reset counter
        start_bit_detected <= 1'b0; // Reset start bit detection flag
        stop_bit_expected <= 1'b0; // Reset stop bit expectation flag
        done <= 1'b0; // Reset done signal
    end else begin
        if (~start_bit_detected) begin // IDLE state
            if (~in) begin // Start bit detected
                start_bit_detected <= 1'b1; // Set start bit detection flag
                data_register <= 8'b0; // Reset data register
                bit_count <= 4'b1; // Increment counter
            end
        end else if (start_bit_detected & ~stop_bit_expected) begin // DATA_BITS state
            data_register <= {data_register[6:0], in}; // Shift in new bit
            bit_count <= bit_count + 1; // Increment counter
            if (bit_count == 4'b1000) begin // 8 bits received
                stop_bit_expected <= 1'b1; // Set stop bit expectation flag
                start_bit_detected <= 1'b0; // Reset start bit detection flag
                bit_count <= 4'b0; // Reset counter
            end
        end else if (stop_bit_expected) begin // STOP_BIT state
            if (in) begin // Stop bit detected
                done <= 1'b1; // Set done signal high
                stop_bit_expected <= 1'b0; // Reset stop bit expectation flag
            end else begin // Stop bit not detected
                stop_bit_expected <= 1'b0; // Reset stop bit expectation flag
                start_bit_detected <= 1'b0; // Reset start bit detection flag
                bit_count <= 4'b0; // Reset counter
            end
        end
    end
end

// Reset done signal after one clock cycle
always @(posedge clk) begin
    if (done) begin
        done <= 1'b0; // Reset done signal
    end
end

endmodule