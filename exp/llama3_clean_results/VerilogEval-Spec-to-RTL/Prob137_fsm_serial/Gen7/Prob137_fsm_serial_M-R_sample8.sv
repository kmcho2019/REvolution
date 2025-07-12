module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [8:0] shift_register; // 9-bit shift register to collect incoming bits
reg [3:0] bit_count; // Counter to keep track of number of bits received
reg state; // 1-bit state register (IDLE, RECEIVE)

always @(posedge clk) begin
    if (reset) begin
        shift_register <= 9'b0; // Reset shift register
        bit_count <= 4'b0; // Reset counter
        state <= 1'b0; // Reset state (IDLE)
        done <= 1'b0; // Reset done signal
    end else begin
        case(state)
            1'b0: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 1'b1; // Transition to RECEIVE state
                    shift_register <= {8'b0, in}; // Load start bit into shift register
                    bit_count <= 4'b1; // Increment counter
                end else if (in) begin // Stop bit detected
                    // Do nothing, stay in IDLE state
                end
            end
            1'b1: begin // RECEIVE state
                shift_register <= {shift_register[7:0], in}; // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
                if (bit_count == 9) begin // 9 bits received
                    if (in) begin // Stop bit correct
                        done <= 1'b1; // Set done signal high
                    end
                    state <= 1'b0; // Transition to IDLE state
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