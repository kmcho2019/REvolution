module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [7:0] data; // 8-bit register to collect incoming data bits
reg [2:0] bit_count; // 3-bit counter to keep track of number of bits received
reg start_bit_detected; // Flag to indicate start bit detection
reg stop_bit_valid; // Flag to indicate stop bit validity

always @(posedge clk) begin
    if (reset) begin
        data <= 8'b0; // Reset data register
        bit_count <= 3'b0; // Reset counter
        start_bit_detected <= 1'b0; // Reset start bit detection flag
        stop_bit_valid <= 1'b0; // Reset stop bit validity flag
        done <= 1'b0; // Reset done signal
    end else begin
        if (~in && ~start_bit_detected) begin
            start_bit_detected <= 1'b1; // Set start bit detection flag
        end
        
        if (start_bit_detected) begin
            if (bit_count < 8) begin
                data <= {data[6:0], in}; // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
            end else if (bit_count == 8) begin
                if (in) begin // Stop bit detected
                    stop_bit_valid <= 1'b1; // Set stop bit validity flag
                end
                bit_count <= bit_count + 1; // Increment counter
            end
            
            if (bit_count == 9) begin
                if (stop_bit_valid) begin
                    done <= 1'b1; // Set done signal high
                end
                start_bit_detected <= 1'b0; // Reset start bit detection flag
                stop_bit_valid <= 1'b0; // Reset stop bit validity flag
                bit_count <= 3'b0; // Reset counter
            end
        end
        
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule