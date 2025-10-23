module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [1:0] state; // 2-bit state register
reg [8:0] shift_register; // 9-bit shift register to collect incoming bits
reg [3:0] bit_count; // Counter to keep track of number of bits received

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b01; // Reset to IDLE state
        shift_register <= 9'b0; // Reset shift register
        bit_count <= 4'b0; // Reset counter
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            2'b01: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 2'b10; // Move to RECEIVE state
                    shift_register <= {8'b0, in}; // Load start bit into shift register
                    bit_count <= 4'b1; // Increment counter
                end
            end
            2'b10: begin // RECEIVE state
                shift_register <= {shift_register[7:0], in}; // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
                if (bit_count == 9) begin // 9 bits received
                    if (in) begin // Stop bit correct
                        done <= 1'b1; // Set done signal high
                        state <= 2'b01; // Move back to IDLE state
                    end else begin // Stop bit incorrect
                        state <= 2'b01; // Move back to IDLE state
                    end
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