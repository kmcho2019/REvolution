module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [7:0] data_register; // 8-bit register to store incoming data bits
reg [2:0] bit_count; // 3-bit counter to track number of bits received
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
                data_register <= 8'b0; // Reset data register
                bit_count <= 3'b1; // Increment counter
            end
        end else if (start_detected && ~wait_stop) begin // RECEIVE state
            data_register <= {data_register[6:0], in}; // Shift in new bit
            bit_count <= bit_count + 1; // Increment counter
            if (bit_count == 3'b1000) begin // 8 bits received
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
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule