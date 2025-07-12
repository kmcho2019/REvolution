module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] state; // State machine states: IDLE, RECEIVE, WAIT_STOP
reg [7:0] data_register; // 8-bit register to collect incoming data bits
reg [3:0] bit_count; // Counter to keep track of number of bits received

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset state machine to IDLE state
        data_register <= 8'b0; // Reset data register
        bit_count <= 4'b0; // Reset counter
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            0: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 1; // Move to RECEIVE state
                    bit_count <= 4'b1; // Increment counter
                end
            end
            1: begin // RECEIVE state
                data_register <= {data_register[6:0], in}; // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
                if (bit_count == 9) begin // 9 bits received
                    if (in) begin // Stop bit correct
                        done <= 1'b1; // Set done signal high
                        state <= 0; // Move to IDLE state
                    end else begin // Stop bit incorrect
                        state <= 2; // Move to WAIT_STOP state
                    end
                    bit_count <= 4'b0; // Reset counter
                end
            end
            2: begin // WAIT_STOP state
                if (in) begin // Stop bit detected
                    state <= 0; // Move to IDLE state
                end
            end
        endcase
        if (state == 0 && done) begin
            done <= 1'b0; // Reset done signal in the next clock cycle
        end
    end
end

endmodule