module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [9:0] shift_register; // 10-bit shift register to collect incoming bits
reg [3:0] bit_count; // Counter to keep track of number of bits received
reg start_detected; // Flag to indicate start bit detection

always @(posedge clk) begin
    if (reset) begin
        shift_register <= 10'b0; // Reset shift register
        bit_count <= 4'b0; // Reset counter
        start_detected <= 1'b0; // Reset start bit detection flag
        done <= 1'b0; // Reset done signal
    end else begin
        if (~start_detected) begin // IDLE state
            if (~in) begin // Start bit detected
                start_detected <= 1'b1; // Set start bit detection flag
                shift_register <= {9'b0, in}; // Load start bit into shift register
                bit_count <= 4'b1; // Increment counter
            end
        end else begin // RECEIVE state
            shift_register <= {shift_register[8:0], in}; // Shift in new bit
            bit_count <= bit_count + 1; // Increment counter
            if (bit_count == 10) begin // 10 bits received
                if (shift_register[9]) begin // Stop bit correct
                    done <= 1'b1; // Set done signal high
                    start_detected <= 1'b0; // Reset start bit detection flag
                end else begin // Stop bit incorrect
                    start_detected <= 1'b0; // Reset start bit detection flag
                end
                bit_count <= 4'b0; // Reset counter
            end
        end
    end
end

always @(posedge clk) begin
    if (~reset) begin
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule