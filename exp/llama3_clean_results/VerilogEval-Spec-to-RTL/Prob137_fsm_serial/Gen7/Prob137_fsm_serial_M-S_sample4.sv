module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [1:0] state; // 2-state finite state machine
reg [7:0] data; // 8-bit shift register for data bits
reg [2:0] bit_count; // Counter to keep track of number of bits received

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE state
        data <= 8'b0; // Reset data bits
        bit_count <= 3'b0; // Reset counter
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 2'b01; // Move to RECEIVE state
                    data <= 8'b0; // Reset data bits
                    bit_count <= 3'b1; // Increment counter
                end
            end
            2'b01: begin // RECEIVE state
                data <= {data[6:0], in}; // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
                if (bit_count == 9) begin // 9 bits received
                    if (in) begin // Stop bit correct
                        state <= 2'b00; // Move back to IDLE state
                        done <= 1'b1; // Set done signal high
                    end else begin // Stop bit incorrect
                        state <= 2'b00; // Move back to IDLE state
                    end
                    bit_count <= 3'b0; // Reset counter
                end
            end
        endcase
        if (state == 2'b00 && ~in) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule