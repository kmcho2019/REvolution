module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [7:0] shift_register; // 8-bit shift register for data bits
reg [3:0] bit_count; // Counter to keep track of number of bits received
reg receiving; // Flag to indicate if we're in the receive state

always @(posedge clk) begin
    if (reset) begin
        receiving <= 1'b0; // Reset to IDLE state
        shift_register <= 8'b0; // Reset shift register
        bit_count <= 4'b0; // Reset counter
        done <= 1'b0; // Reset done signal
    end else begin
        if (~receiving) begin // IDLE state
            if (~in) begin // Start bit detected
                receiving <= 1'b1; // Move to RECEIVE state
                shift_register <= {7'b0, in}; // Load start bit into shift register (not actually needed)
                bit_count <= 4'b1; // Increment counter
            end
        end else begin // RECEIVE state
            shift_register <= {shift_register[6:0], in}; // Shift in new bit
            bit_count <= bit_count + 1; // Increment counter
            if (bit_count == 9) begin // 9 bits received
                if (in) begin // Stop bit correct
                    done <= 1'b1; // Set done signal high
                end
                receiving <= 1'b0; // Move back to IDLE state
                bit_count <= 4'b0; // Reset counter
            end else if (bit_count > 9 && in) begin // Incorrect stop bit, wait for stop bit
                receiving <= 1'b0; // Move back to IDLE state
                bit_count <= 4'b0; // Reset counter
            end
        end
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule