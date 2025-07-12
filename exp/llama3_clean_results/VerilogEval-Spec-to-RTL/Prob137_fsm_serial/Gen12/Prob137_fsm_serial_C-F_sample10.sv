module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] state; // 3-bit one-hot encoded state register
reg [8:0] shift_register; // 9-bit shift register to collect incoming bits
reg [2:0] bit_count; // 3-bit counter to keep track of number of bits received

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b001; // Reset to IDLE state
        shift_register <= 9'b0; // Reset shift register
        bit_count <= 3'b0; // Reset counter
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            3'b001: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 3'b010; // Transition to RECEIVE state
                    shift_register <= {8'b0, in}; // Load start bit into shift register
                    bit_count <= 3'b1; // Increment counter
                end
            end
            3'b010: begin // RECEIVE state
                shift_register <= {shift_register[7:0], in}; // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
                if (bit_count == 3'b1000) begin // 9 bits received
                    if (in) begin // Stop bit correct
                        done <= 1'b1; // Set done signal high
                        state <= 3'b001; // Transition to IDLE state
                    end else begin // Stop bit incorrect
                        state <= 3'b100; // Transition to WAIT_STOP state
                    end
                    bit_count <= 3'b0; // Reset counter
                end
            end
            3'b100: begin // WAIT_STOP state
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