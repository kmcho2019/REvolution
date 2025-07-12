module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [1:0] state; // 2-state FSM: IDLE, RECEIVE
reg [7:0] received_byte; // 8-bit register to store the received byte
reg [3:0] bit_count; // Counter to keep track of number of bits received

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b01; // Reset state to IDLE
        received_byte <= 8'b0; // Reset received byte
        bit_count <= 4'b0; // Reset counter
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            2'b01: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 2'b10; // Transition to RECEIVE state
                    received_byte <= 8'b0; // Reset received byte
                    bit_count <= 4'b1; // Increment counter
                end
            end
            2'b10: begin // RECEIVE state
                received_byte <= (received_byte >> 1) | (in << 7); // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
                if (bit_count == 9) begin // 9 bits received
                    if (in) begin // Stop bit correct
                        done <= 1'b1; // Set done signal high
                        state <= 2'b01; // Transition to IDLE state
                    end else begin // Stop bit incorrect
                        state <= 2'b01; // Transition to IDLE state
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