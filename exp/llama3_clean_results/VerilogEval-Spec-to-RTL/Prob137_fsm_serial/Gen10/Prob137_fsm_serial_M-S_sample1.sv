module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [8:0] shift_register; // 9-bit shift register
reg [3:0] bit_count; // Counter for bits received
reg fsm_state; // Single-bit FSM state (IDLE or RECEIVE)

always @(posedge clk) begin
    if (reset) begin
        shift_register <= 9'b0; // Reset shift register
        bit_count <= 4'b0; // Reset counter
        fsm_state <= 1'b0; // Reset FSM state to IDLE
        done <= 1'b0; // Reset done signal
    end else begin
        case(fsm_state)
            1'b0: begin // IDLE state
                if (~in) begin // Start bit detected
                    fsm_state <= 1'b1; // Transition to RECEIVE state
                    shift_register <= {8'b0, in}; // Load start bit
                    bit_count <= 4'b1; // Increment counter
                end
            end
            1'b1: begin // RECEIVE state
                shift_register <= {shift_register[7:0], in}; // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
                if (bit_count == 9) begin // 9 bits received
                    if (in) begin // Stop bit correct
                        done <= 1'b1; // Set done signal high
                    end
                    fsm_state <= 1'b0; // Transition to IDLE state
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