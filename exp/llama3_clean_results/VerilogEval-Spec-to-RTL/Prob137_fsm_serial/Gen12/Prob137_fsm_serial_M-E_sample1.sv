module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [1:0] state; // 2-bit state register
reg [7:0] data; // 8-bit data register
reg [3:0] bit_count; // Counter to keep track of number of bits received
reg start_bit_detected; // Flag to indicate start bit detection

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to IDLE state
        data <= 8'b0; // Reset data register
        bit_count <= 4'b0; // Reset counter
        start_bit_detected <= 1'b0; // Reset start bit detection flag
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 2'b01; // Move to RECEIVE state
                    start_bit_detected <= 1'b1; // Set start bit detection flag
                end
            end
            2'b01: begin // RECEIVE state
                if (start_bit_detected) begin
                    data[0] <= in; // Load start bit into data register
                    start_bit_detected <= 1'b0; // Reset start bit detection flag
                    bit_count <= 4'b1; // Increment counter
                end else begin
                    data <= {data[6:0], in}; // Shift in new bit
                    bit_count <= bit_count + 1; // Increment counter
                end
                if (bit_count == 9) begin // 9 bits received
                    if (in) begin // Stop bit correct
                        done <= 1'b1; // Set done signal high
                    end
                    state <= 2'b00; // Move back to IDLE state
                    bit_count <= 4'b0; // Reset counter
                end
            end
        endcase
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule