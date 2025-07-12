module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [1:0] state; // 2-bit state register (IDLE, RECEIVE, WAIT_STOP)
reg [2:0] bit_count; // 3-bit counter to keep track of number of bits received
reg [7:0] data; // 8-bit register to collect incoming data bits

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset state to IDLE
        bit_count <= 3'b0; // Reset counter
        data <= 8'b0; // Reset data register
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            2'b00: // IDLE state
                if (~in) begin // Start bit detected
                    state <= 2'b01; // Transition to RECEIVE state
                    bit_count <= 3'b1; // Increment counter
                end
            2'b01: // RECEIVE state
                data <= {data[6:0], in}; // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
                if (bit_count == 9) begin // 9 bits received
                    if (in) begin // Stop bit correct
                        done <= 1'b1; // Set done signal high
                        state <= 2'b00; // Transition to IDLE state
                    end else begin // Stop bit incorrect
                        state <= 2'b10; // Transition to WAIT_STOP state
                    end
                    bit_count <= 3'b0; // Reset counter
                end
            2'b10: // WAIT_STOP state
                if (in) begin // Stop bit detected
                    state <= 2'b00; // Transition to IDLE state
                end
        endcase
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule