module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [3:0] bit_count; // Counter to keep track of number of bits received
reg [7:0] byte; // Shift register to store the received byte
reg start_bit_detected; // Flag to indicate if a start bit has been detected
reg timeout; // Flag to indicate if a timeout has occurred

always @(posedge clk) begin
    if (reset) begin
        bit_count <= 4'b0; // Reset bit counter
        byte <= 8'b0; // Reset byte register
        start_bit_detected <= 1'b0; // Reset start bit detected flag
        timeout <= 1'b0; // Reset timeout flag
        done <= 1'b0; // Reset done signal
    end else begin
        if (~in && ~start_bit_detected) begin // Start bit detected
            start_bit_detected <= 1'b1; // Set start bit detected flag
            bit_count <= 4'b1; // Reset bit counter
        end else if (start_bit_detected) begin
            byte <= {byte[6:0], in}; // Shift in new bit
            bit_count <= bit_count + 1; // Increment bit counter
            if (bit_count == 4'd9) begin // 9 bits received
                if (in) begin // Stop bit correct
                    done <= 1'b1; // Set done signal high
                end
                start_bit_detected <= 1'b0; // Reset start bit detected flag
                bit_count <= 4'b0; // Reset bit counter
            end
        end
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule