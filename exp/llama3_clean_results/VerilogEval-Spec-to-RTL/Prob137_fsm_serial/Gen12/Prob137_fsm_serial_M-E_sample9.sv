module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg start_bit_detected; // Flag to track start bit detection
reg [7:0] data_bits; // Register to store collected data bits
reg [3:0] bit_count; // Counter to track number of bits received
reg stop_bit_verified; // Flag to track stop bit verification

always @(posedge clk) begin
    if (reset) begin
        start_bit_detected <= 1'b0; // Reset start bit detection flag
        data_bits <= 8'b0; // Reset data bits register
        bit_count <= 4'b0; // Reset bit counter
        stop_bit_verified <= 1'b0; // Reset stop bit verification flag
        done <= 1'b0; // Reset done signal
    end else begin
        if (~in && ~start_bit_detected) begin // Start bit detected
            start_bit_detected <= 1'b1; // Set start bit detection flag
            bit_count <= 4'b1; // Initialize bit counter
        end else if (start_bit_detected && bit_count < 9) begin // Collect data bits
            data_bits <= {data_bits[6:0], in}; // Shift in new data bit
            bit_count <= bit_count + 1; // Increment bit counter
        end else if (bit_count == 9) begin // Stop bit verification
            if (in) begin // Stop bit correct
                stop_bit_verified <= 1'b1; // Set stop bit verification flag
                done <= 1'b1; // Set done signal high
            end else begin // Stop bit incorrect
                start_bit_detected <= 1'b0; // Reset start bit detection flag
                bit_count <= 4'b0; // Reset bit counter
            end
        end else if (stop_bit_verified) begin // Reset flags after stop bit verification
            start_bit_detected <= 1'b0; // Reset start bit detection flag
            stop_bit_verified <= 1'b0; // Reset stop bit verification flag
            bit_count <= 4'b0; // Reset bit counter
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule