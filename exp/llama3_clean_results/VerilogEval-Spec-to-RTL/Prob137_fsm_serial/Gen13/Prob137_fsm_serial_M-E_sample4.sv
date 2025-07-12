module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [7:0] data_register; // 8-bit register to collect data bits
reg [3:0] bit_count; // Counter to keep track of number of bits received
reg start_bit_detected; // Flag to indicate start bit detection
reg stop_bit_verified; // Flag to indicate stop bit verification

always @(posedge clk) begin
    if (reset) begin
        data_register <= 8'b0; // Reset data register
        bit_count <= 4'b0; // Reset counter
        start_bit_detected <= 1'b0; // Reset start bit detection flag
        stop_bit_verified <= 1'b0; // Reset stop bit verification flag
        done <= 1'b0; // Reset done signal
    end else begin
        if (~start_bit_detected) begin // Wait for start bit
            if (~in) begin // Start bit detected
                start_bit_detected <= 1'b1; // Set start bit detection flag
                bit_count <= 4'b1; // Increment counter
            end
        end else begin // Start bit detected, collect data bits
            if (bit_count < 9) begin
                if (bit_count == 1) begin // Shift in first data bit
                    data_register[0] <= in;
                end else if (bit_count == 2) begin // Shift in second data bit
                    data_register[1] <= in;
                end else if (bit_count == 3) begin // Shift in third data bit
                    data_register[2] <= in;
                end else if (bit_count == 4) begin // Shift in fourth data bit
                    data_register[3] <= in;
                end else if (bit_count == 5) begin // Shift in fifth data bit
                    data_register[4] <= in;
                end else if (bit_count == 6) begin // Shift in sixth data bit
                    data_register[5] <= in;
                end else if (bit_count == 7) begin // Shift in seventh data bit
                    data_register[6] <= in;
                end else if (bit_count == 8) begin // Shift in eighth data bit
                    data_register[7] <= in;
                end
                bit_count <= bit_count + 1; // Increment counter
            end else if (bit_count == 9) begin // Stop bit
                if (in) begin // Stop bit verified
                    stop_bit_verified <= 1'b1; // Set stop bit verification flag
                    done <= 1'b1; // Set done signal high
                end else begin // Stop bit not verified, wait for stop bit
                    start_bit_detected <= 1'b0; // Reset start bit detection flag
                    bit_count <= 4'b0; // Reset counter
                end
            end
        end
        if (stop_bit_verified) begin
            start_bit_detected <= 1'b0; // Reset start bit detection flag
            stop_bit_verified <= 1'b0; // Reset stop bit verification flag
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule