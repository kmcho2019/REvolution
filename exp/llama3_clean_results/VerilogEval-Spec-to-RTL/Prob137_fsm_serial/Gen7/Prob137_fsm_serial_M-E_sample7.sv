module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [9:0] bit_accumulator; // 10-bit register to accumulate incoming bits
reg [3:0] bit_count; // Counter to keep track of number of bits received
reg start_bit_detected; // Flag to indicate start bit detection
reg stop_bit_verified; // Flag to indicate stop bit verification

always @(posedge clk) begin
    if (reset) begin
        bit_accumulator <= 10'b0; // Reset bit accumulator
        bit_count <= 4'b0; // Reset counter
        start_bit_detected <= 1'b0; // Reset start bit detection flag
        stop_bit_verified <= 1'b0; // Reset stop bit verification flag
        done <= 1'b0; // Reset done signal
    end else begin
        if (~in && ~start_bit_detected) begin // Start bit detection
            start_bit_detected <= 1'b1; // Set start bit detection flag
            bit_accumulator <= {9'b0, in}; // Load start bit into bit accumulator
            bit_count <= 4'b1; // Increment counter
        end else if (start_bit_detected && bit_count < 10) begin // Bit accumulation
            bit_accumulator <= {bit_accumulator[8:0], in}; // Shift in new bit
            bit_count <= bit_count + 1; // Increment counter
        end else if (bit_count == 10) begin // Stop bit verification
            if (in) begin // Stop bit correct
                stop_bit_verified <= 1'b1; // Set stop bit verification flag
                done <= 1'b1; // Set done signal high
            end else begin // Stop bit incorrect
                start_bit_detected <= 1'b0; // Reset start bit detection flag
                bit_count <= 4'b0; // Reset counter
            end
        end
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule