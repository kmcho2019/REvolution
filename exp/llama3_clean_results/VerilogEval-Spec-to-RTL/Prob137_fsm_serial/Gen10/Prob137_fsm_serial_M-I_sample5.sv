module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [9:0] shift_count; // 10-bit register to collect incoming bits and count
reg [1:0] state; // 2-bit state register (IDLE, RECEIVE, WAIT_STOP)

always @(posedge clk) begin
    if (reset) begin
        shift_count <= 10'b0; // Reset shift register and counter
        state <= 2'b0; // Reset state (IDLE)
        done <= 1'b0; // Reset done signal
    end else begin
        case(state)
            2'b00: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 2'b01; // Transition to RECEIVE state
                    shift_count <= {9'b0, in}; // Load start bit into shift register
                end
            end
            2'b01: begin // RECEIVE state
                shift_count <= {shift_count[8:0], in}; // Shift in new bit and increment counter
                if (shift_count[9]) begin // 9 bits received
                    if (in) begin // Stop bit correct
                        done <= 1'b1; // Set done signal high
                        state <= 2'b00; // Transition to IDLE state
                    end else begin // Stop bit incorrect
                        state <= 2'b10; // Transition to WAIT_STOP state
                    end
                end
            end
            2'b10: begin // WAIT_STOP state
                if (in) begin // Stop bit detected
                    state <= 2'b00; // Transition to IDLE state
                end
            end
        endcase
        if (done && (state == 2'b00)) begin
            done <= 1'b0; // Reset done signal when returning to IDLE state
        end
    end
end

endmodule