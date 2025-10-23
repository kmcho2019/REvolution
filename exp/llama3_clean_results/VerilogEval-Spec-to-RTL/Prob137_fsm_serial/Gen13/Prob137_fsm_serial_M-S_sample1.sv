module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] bit_count; // Counter to keep track of number of bits received
reg [7:0] data; // Register to store the received data
reg start_detected; // Flag to indicate start bit detection

always @(posedge clk) begin
    if (reset) begin
        bit_count <= 3'b0; // Reset counter
        start_detected <= 1'b0; // Reset start bit detection flag
        done <= 1'b0; // Reset done signal
        data <= 8'b0; // Reset data register
    end else begin
        if (~start_detected) begin // IDLE state
            if (~in) begin // Start bit detected
                start_detected <= 1'b1; // Set start bit detection flag
                bit_count <= 3'b1; // Increment counter
                data[0] <= ~in; // Load start bit into data register
            end
        end else begin // RECEIVE state
            data <= {data[6:0], ~in}; // Shift in new bit
            bit_count <= bit_count + 1; // Increment counter
            if (bit_count == 8) begin // 8 bits received
                start_detected <= 1'b0; // Reset start bit detection flag
                if (in) begin // Stop bit correct
                    done <= 1'b1; // Set done signal high
                end
                bit_count <= 3'b0; // Reset counter
            end
        end
    end
    if (done) begin
        done <= 1'b0; // Reset done signal
    end
end

endmodule