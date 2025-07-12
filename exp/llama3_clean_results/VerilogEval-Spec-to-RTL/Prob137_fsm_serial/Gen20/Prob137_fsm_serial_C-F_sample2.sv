module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [3:0] state; // 4-bit one-hot encoded state register
reg [8:0] shift_register; // 9-bit shift register
reg [3:0] bit_count; // Counter to keep track of number of bits received

always @(posedge clk) begin
    if (reset) begin
        state <= 4'b0001; // Reset to IDLE state
        shift_register <= 9'b0; // Reset shift register
        bit_count <= 4'b0; // Reset counter
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            4'b0001: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 4'b0010; // Move to RECEIVE state
                    shift_register <= {8'b0, in}; // Load start bit into shift register
                    bit_count <= 4'b1; // Increment counter
                end
            end
            4'b0010: begin // RECEIVE state
                shift_register <= {shift_register[7:0], in}; // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
                if (bit_count == 9) begin // 9 bits received
                    if (in) begin // Stop bit correct
                        state <= 4'b1000; // Move to DONE state
                    end else begin // Stop bit incorrect
                        state <= 4'b0100; // Move to WAIT_STOP state
                    end
                    bit_count <= 4'b0; // Reset counter
                end
            end
            4'b0100: begin // WAIT_STOP state
                if (in) begin // Stop bit detected
                    state <= 4'b0001; // Move back to IDLE state
                end
            end
            4'b1000: begin // DONE state
                done <= 1'b1; // Set done signal high
                state <= 4'b0001; // Move back to IDLE state
            end
        endcase
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule