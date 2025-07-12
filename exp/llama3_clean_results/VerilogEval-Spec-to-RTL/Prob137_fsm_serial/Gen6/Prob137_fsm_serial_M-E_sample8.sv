module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [8:0] shift_register; // 9-bit shift register to collect incoming bits
reg [1:0] state; // 2-bit state register (IDLE, RECEIVE)
reg clk_gated; // Gated clock for shift register

always @(posedge clk) begin
    if (reset) begin
        shift_register <= 9'b0; // Reset shift register
        state <= 2'b0; // Reset state (IDLE)
        done <= 1'b0; // Reset done signal
    end else begin
        case(state)
            2'b01: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 2'b10; // Transition to RECEIVE state
                    shift_register <= {8'b0, in}; // Load start bit into shift register
                    clk_gated <= 1'b1; // Enable gated clock
                end
            end
            2'b10: begin // RECEIVE state
                if (clk_gated) begin
                    shift_register <= {shift_register[7:0], in}; // Shift in new bit
                    if (shift_register[8]) begin // 9 bits received
                        if (in) begin // Stop bit correct
                            done <= 1'b1; // Set done signal high
                            state <= 2'b01; // Transition to IDLE state
                            clk_gated <= 1'b0; // Disable gated clock
                        end else begin // Stop bit incorrect
                            state <= 2'b10; // Stay in RECEIVE state
                        end
                    end
                end
            end
        endcase
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule