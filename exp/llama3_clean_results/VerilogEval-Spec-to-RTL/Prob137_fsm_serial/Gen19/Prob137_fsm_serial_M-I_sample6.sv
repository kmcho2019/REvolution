module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [7:0] data_register; // 8-bit register to collect data bits
reg [2:0] bit_count; // 3-bit counter to keep track of number of bits received
reg start_detected; // Flag to indicate start bit detection
reg wait_stop; // Flag to wait for stop bit

always @(posedge clk) begin
    if (reset) begin
        data_register <= 8'b0; // Reset data register
        bit_count <= 3'b0; // Reset counter
        start_detected <= 1'b0; // Reset start bit detection flag
        wait_stop <= 1'b0; // Reset wait stop flag
        done <= 1'b0; // Reset done signal
    end else begin
        if (~start_detected && ~wait_stop) begin // IDLE state
            if (~in) begin // Start bit detected
                start_detected <= 1'b1; // Set start bit detection flag
                bit_count <= 3'b1; // Increment counter
                data_register[0] <= ~in; // Load start bit into data register (inverted)
            end
        end else if (start_detected && ~wait_stop) begin // RECEIVE state
            if (bit_count < 8) begin
                data_register[bit_count] <= in; // Load data bit into data register
                bit_count <= bit_count + 1; // Increment counter
            end
            if (bit_count == 8) begin // 8 data bits received
                if (in) begin // Stop bit correct
                    done <= 1'b1; // Set done signal high
                    start_detected <= 1'b0; // Reset start bit detection flag
                    wait_stop <= 1'b0; // Reset wait stop flag
                end else begin // Stop bit incorrect
                    wait_stop <= 1'b1; // Set wait stop flag
                    start_detected <= 1'b0; // Reset start bit detection flag
                end
                bit_count <= 3'b0; // Reset counter
            end
        end else if (wait_stop) begin // WAIT_STOP state
            if (in) begin // Stop bit detected
                wait_stop <= 1'b0; // Reset wait stop flag
            end
        end
        if (done && ~start_detected) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule