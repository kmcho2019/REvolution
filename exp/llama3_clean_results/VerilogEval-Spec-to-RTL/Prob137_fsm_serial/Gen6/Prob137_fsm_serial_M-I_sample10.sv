module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] state; // 3-state finite state machine
reg [8:0] shift_register; // 9-bit shift register
reg [3:0] bit_count; // Counter to keep track of number of bits received

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // IDLE state
        shift_register <= 9'b0; // Reset shift register
        bit_count <= 4'b0; // Reset counter
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            3'b000: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 3'b001; // Move to RECEIVE state
                    shift_register <= {8'b0, in}; // Load start bit into shift register
                    bit_count <= 4'b1; // Increment counter
                end
            end
            3'b001: begin // RECEIVE state
                shift_register <= {shift_register[7:0], in}; // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
                if (bit_count == 9) begin // 9 bits received
                    if (in) begin // Stop bit correct
                        state <= 3'b000; // Move back to IDLE state
                        done <= 1'b1; // Set done signal high
                    end else begin // Stop bit incorrect
                        state <= 3'b010; // Move to WAIT_STOP state
                    end
                    bit_count <= 4'b0; // Reset counter
                end
            end
            3'b010: begin // WAIT_STOP state
                if (in) begin // Stop bit detected
                    state <= 3'b000; // Move back to IDLE state
                end
            end
        endcase
        if (state == 3'b000 && ~in) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule