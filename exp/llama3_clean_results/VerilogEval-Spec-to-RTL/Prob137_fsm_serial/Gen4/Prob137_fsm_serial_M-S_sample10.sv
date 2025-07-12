module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [7:0] data; // 8-bit register to collect incoming data bits
reg [3:0] bit_count; // Counter to keep track of number of bits received
reg start_detected; // Flag to indicate start bit detection

always @(posedge clk) begin
    if (reset) begin
        data <= 8'b0; // Reset data register
        bit_count <= 4'b0; // Reset counter
        start_detected <= 1'b0; // Reset start bit detection flag
        done <= 1'b0; // Reset done signal
    end else begin
        if (~start_detected) begin // IDLE state
            if (~in) begin // Start bit detected
                start_detected <= 1'b1; // Set start bit detection flag
                bit_count <= 4'b1; // Increment counter
                data <= {7'b0, in}; // Load start bit into data register
            end else if (in) begin // Stop bit detected, wait for start bit
                start_detected <= 1'b0; // Reset start bit detection flag
            end
        end else begin // RECEIVE state
            data <= {data[6:0], in}; // Shift in new bit
            bit_count <= bit_count + 1; // Increment counter
            if (bit_count == 9) begin // 9 bits received
                if (in) begin // Stop bit correct
                    done <= 1'b1; // Set done signal high
                end
                start_detected <= 1'b0; // Reset start bit detection flag
                bit_count <= 4'b0; // Reset counter
            end
        end
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule