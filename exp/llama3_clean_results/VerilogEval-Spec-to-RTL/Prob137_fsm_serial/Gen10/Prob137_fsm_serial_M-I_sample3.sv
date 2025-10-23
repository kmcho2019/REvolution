module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [7:0] data_register; // 8-bit data register
reg [2:0] bit_count; // 3-bit counter for bits received
reg [1:0] state; // 2-bit state register (IDLE, RECEIVE, WAIT_STOP)

always @(posedge clk) begin
    if (reset) begin
        data_register <= 8'b0; // Reset data register
        bit_count <= 3'b0; // Reset counter
        state <= 2'b00; // Reset state to IDLE
        done <= 1'b0; // Reset done signal
    end else begin
        case(state)
            2'b00: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 2'b01; // Transition to RECEIVE state
                    data_register <= 8'b0; // Reset data register
                    bit_count <= 3'b1; // Increment counter
                end
            end
            2'b01: begin // RECEIVE state
                data_register <= {data_register[6:0], in}; // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
                if (bit_count == 8) begin // 8 bits received
                    if (in) begin // Stop bit correct (assuming stop bit is part of the protocol but not stored)
                        done <= 1'b1; // Set done signal high
                        state <= 2'b00; // Transition to IDLE state
                    end else begin // Stop bit incorrect
                        state <= 2'b10; // Transition to WAIT_STOP state
                    end
                    bit_count <= 3'b0; // Reset counter
                end
            end
            2'b10: begin // WAIT_STOP state
                if (in) begin // Stop bit detected
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