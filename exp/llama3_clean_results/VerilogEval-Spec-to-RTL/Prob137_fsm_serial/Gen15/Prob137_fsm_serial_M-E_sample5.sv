module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [8:0] sipo_shift_register; // 9-bit SIPO shift register
reg [3:0] gray_code_counter; // Gray code counter
reg start_bit_detected; // Flag to detect start bit

always @(posedge clk) begin
    if (reset) begin
        sipo_shift_register <= 9'b0; // Reset SIPO shift register
        gray_code_counter <= 4'b0; // Reset Gray code counter
        start_bit_detected <= 1'b0; // Reset start bit detection flag
        done <= 1'b0; // Reset done signal
    end else begin
        if (~start_bit_detected) begin // IDLE state
            if (~in) begin // Start bit detected
                start_bit_detected <= 1'b1; // Set start bit detection flag
                sipo_shift_register <= {8'b0, in}; // Load start bit into SIPO shift register
                gray_code_counter <= gray_code_counter + 1; // Increment Gray code counter
            end
        end else begin // RECEIVE state
            sipo_shift_register <= {sipo_shift_register[7:0], in}; // Shift in new bit
            gray_code_counter <= gray_code_counter + 1; // Increment Gray code counter
            if (gray_code_counter == 10) begin // 9 bits received
                if (in) begin // Stop bit correct
                    done <= 1'b1; // Set done signal high
                    start_bit_detected <= 1'b0; // Reset start bit detection flag
                    gray_code_counter <= 4'b0; // Reset Gray code counter
                end else begin // Stop bit incorrect
                    gray_code_counter <= 4'b0; // Reset Gray code counter
                end
            end
        end
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule