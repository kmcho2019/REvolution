module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [7:0] data; // 8-bit data register
reg [3:0] bit_count; // Counter to keep track of number of bits received
reg start_detected; // Flag to indicate start bit detection
reg wait_stop; // Flag to wait for stop bit

always @(posedge clk) begin
    if (reset) begin
        data <= 8'b0; // Reset data register
        bit_count <= 4'b0; // Reset counter
        start_detected <= 1'b0; // Reset start bit detection flag
        wait_stop <= 1'b0; // Reset wait stop flag
        done <= 1'b0; // Reset done signal
    end else begin
        if (~start_detected && ~wait_stop && ~in) begin // IDLE state, start bit detected
            start_detected <= 1'b1; // Set start bit detection flag
            data <= 8'b0; // Reset data register
            bit_count <= 4'b1; // Increment counter
        end else if (start_detected && ~wait_stop) begin // RECEIVE state
            if (bit_count < 9) begin
                data <= {data[6:0], in}; // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
            end
            if (bit_count == 9) begin // 9 bits received
                if (in) begin // Stop bit correct
                    done <= 1'b1; // Set done signal high
                    start_detected <= 1'b0; // Reset start bit detection flag
                    wait_stop <= 1'b0; // Reset wait stop flag
                    bit_count <= 4'b0; // Reset counter
                end else begin // Stop bit incorrect
                    wait_stop <= 1'b1; // Set wait stop flag
                    start_detected <= 1'b0; // Reset start bit detection flag
                    bit_count <= 4'b0; // Reset counter
                end
            end
        end else if (wait_stop) begin // WAIT_STOP state
            if (in) begin // Stop bit detected
                wait_stop <= 1'b0; // Reset wait stop flag
            end
        end
    end
end

endmodule