module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [7:0] data_register; // 8-bit register to collect data bits
reg start_bit; // Flag to indicate start bit detection
reg [2:0] bit_count; // 3-bit counter to keep track of number of bits received
reg state; // 1-bit state register (IDLE, RECEIVE)

always @(posedge clk) begin
    if (reset) begin
        data_register <= 8'b0; // Reset data register
        start_bit <= 1'b0; // Reset start bit flag
        bit_count <= 3'b0; // Reset counter
        state <= 1'b0; // Reset state (IDLE)
        done <= 1'b0; // Reset done signal
    end else begin
        case(state)
            1'b0: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 1'b1; // Transition to RECEIVE state
                    start_bit <= 1'b1; // Set start bit flag
                    bit_count <= 3'b1; // Increment counter
                end
            end
            1'b1: begin // RECEIVE state
                data_register <= {data_register[6:0], in}; // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
                if (bit_count == 8) begin // 8 data bits received
                    if (in) begin // Stop bit correct
                        done <= 1'b1; // Set done signal high
                        state <= 1'b0; // Transition to IDLE state
                    end else begin // Stop bit incorrect, wait for stop bit
                        state <= 1'b0; // Transition to IDLE state, waiting for stop bit
                    end
                    bit_count <= 3'b0; // Reset counter
                end
            end
        endcase
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule