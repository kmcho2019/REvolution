module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] state; // 3-bit state register
reg [7:0] shift_register; // 8-bit shift register to collect incoming bits
reg [3:0] bit_count; // Counter to keep track of number of bits received
reg start_bit; // Flag to indicate start bit detection

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b001; // Reset state to IDLE
        shift_register <= 8'b0; // Reset shift register
        bit_count <= 4'b0; // Reset counter
        start_bit <= 1'b0; // Reset start bit detection flag
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            3'b001: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 3'b010; // Transition to RECEIVE state
                    shift_register <= 8'b0; // Reset shift register
                    bit_count <= 4'b1; // Increment counter
                    start_bit <= 1'b1; // Set start bit detection flag
                end
            end
            3'b010: begin // RECEIVE state
                shift_register <= {shift_register[6:0], in}; // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
                if (bit_count == 9) begin // 9 bits received
                    if (in) begin // Stop bit correct
                        done <= 1'b1; // Set done signal high
                        state <= 3'b001; // Transition to IDLE state
                        start_bit <= 1'b0; // Reset start bit detection flag
                    end else begin // Stop bit incorrect
                        state <= 3'b011; // Transition to WAIT_STOP state
                        start_bit <= 1'b0; // Reset start bit detection flag
                    end
                    bit_count <= 4'b0; // Reset counter
                end
            end
            3'b011: begin // WAIT_STOP state
                if (in) begin // Stop bit detected
                    state <= 3'b001; // Transition to IDLE state
                end
            end
        endcase
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule