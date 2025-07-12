module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [3:0] state; // 4-bit state register (IDLE, RECEIVE, WAIT_STOP)
reg [7:0] data; // 8-bit data register
reg [2:0] bit_count; // 3-bit counter for bits received

always @(posedge clk) begin
    if (reset) begin
        state <= 4'b0000; // Reset state to IDLE
        data <= 8'b0; // Reset data register
        bit_count <= 3'b000; // Reset counter
        done <= 1'b0; // Reset done signal
    end else begin
        case(state)
            4'b0000: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 4'b0001; // Transition to RECEIVE state
                    data <= 8'b0; // Reset data register
                    bit_count <= 3'b001; // Increment counter
                end
            end
            4'b0001: begin // RECEIVE state
                data <= {data[6:0], in}; // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
                if (bit_count == 3'b100) begin // 8 bits received
                    state <= 4'b0010; // Transition to WAIT_STOP state
                end
            end
            4'b0010: begin // WAIT_STOP state
                if (in) begin // Stop bit detected
                    done <= 1'b1; // Set done signal high
                    state <= 4'b0000; // Transition to IDLE state
                end else begin // Stop bit incorrect
                    state <= 4'b0011; // Transition to WAIT_STOP state
                end
            end
            4'b0011: begin // WAIT_STOP state
                if (in) begin // Stop bit detected
                    state <= 4'b0000; // Transition to IDLE state
                end
            end
        endcase
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule