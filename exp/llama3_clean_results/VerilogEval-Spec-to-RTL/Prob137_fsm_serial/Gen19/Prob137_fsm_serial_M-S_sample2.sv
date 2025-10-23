module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [1:0] state; // 2-bit state register (IDLE, RECEIVE)
reg [8:0] shift_register; // 9-bit shift register to collect incoming bits

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset state (IDLE)
        shift_register <= 9'b0; // Reset shift register
        done <= 1'b0; // Reset done signal
    end else begin
        case(state)
            2'b00: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 2'b01; // Transition to RECEIVE state
                    shift_register <= {8'b0, in}; // Load start bit into shift register
                end
            end
            2'b01: begin // RECEIVE state
                shift_register <= {shift_register[7:0], in}; // Shift in new bit
                if (&shift_register[8:1]) begin // Check if all 8 data bits received
                    if (in) begin // Stop bit correct
                        done <= 1'b1; // Set done signal high
                    end
                    state <= 2'b00; // Transition to IDLE state
                end
            end
        endcase
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule