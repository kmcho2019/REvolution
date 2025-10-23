module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [1:0] state; // 2-bit state register
reg [8:0] shift_register; // 9-bit shift register
reg [3:0] bit_count; // Counter to keep track of number of bits received
reg start_detected; // Flag to indicate when a start bit has been detected

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to IDLE state
        shift_register <= 9'b0; // Reset shift register
        bit_count <= 4'b0; // Reset counter
        start_detected <= 1'b0; // Reset start detected flag
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 2'b01; // Move to START state
                    shift_register <= {8'b0, in}; // Load start bit into shift register
                    bit_count <= 4'b1; // Increment counter
                    start_detected <= 1'b1; // Set start detected flag
                end
            end
            2'b01: begin // START state
                shift_register <= {shift_register[7:0], in}; // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
                if (bit_count == 9) begin // 9 bits received
                    state <= 2'b10; // Move to STOP state
                end
            end
            2'b10: begin // STOP state
                if (in) begin // Stop bit correct
                    done <= 1'b1; // Set done signal high
                    state <= 2'b00; // Move back to IDLE state
                    start_detected <= 1'b0; // Reset start detected flag
                    bit_count <= 4'b0; // Reset counter
                end else begin // Stop bit incorrect
                    state <= 2'b11; // Move to ERROR state
                end
            end
            2'b11: begin // ERROR state
                if (in) begin // Stop bit detected
                    state <= 2'b00; // Move back to IDLE state
                    start_detected <= 1'b0; // Reset start detected flag
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