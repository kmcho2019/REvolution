module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [8:0] byte_register; // Single 9-bit register to store incoming bits
reg [1:0] state; // State register for Moore machine

always @(posedge clk) begin
    if (reset) begin
        byte_register <= 9'b0; // Reset byte register
        state <= 2'b00; // Reset state to IDLE
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (~in) begin // Start bit detected
                    byte_register[0] <= in; // Load start bit into byte register
                    state <= 2'b01; // Transition to RECEIVE state
                end
            end
            2'b01: begin // RECEIVE state
                byte_register <= {byte_register[7:0], in}; // Shift in new bit
                if (byte_register[8]) begin // 9 bits received
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
        if (state == 2'b00) begin
            done <= 1'b0; // Reset done signal in IDLE state
        end
    end
end

endmodule