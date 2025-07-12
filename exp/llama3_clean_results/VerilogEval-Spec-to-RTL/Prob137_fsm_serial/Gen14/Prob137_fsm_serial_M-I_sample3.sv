module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [7:0] data; // 8-bit register to collect incoming data bits
reg [2:0] state; // 3-bit state register (IDLE, RECEIVE, WAIT_STOP)
reg [3:0] bit_count; // Counter to keep track of number of bits received

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b001; // Reset to IDLE state
        bit_count <= 4'b0; // Reset counter
        data <= 8'b0; // Reset data register
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            3'b001: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 3'b010; // Move to RECEIVE state
                    bit_count <= 4'b1; // Increment counter
                    data <= {7'b0, in}; // Load start bit into data register
                end
            end
            3'b010: begin // RECEIVE state
                if (bit_count < 9) begin
                    data <= {data[6:0], in}; // Shift in new bit
                    bit_count <= bit_count + 1; // Increment counter
                end else if (in) begin // Stop bit correct
                    done <= 1'b1; // Set done signal high
                    state <= 3'b001; // Reset to IDLE state
                    bit_count <= 4'b0; // Reset counter
                end else begin // Stop bit incorrect
                    state <= 3'b100; // Move to WAIT_STOP state
                end
            end
            3'b100: begin // WAIT_STOP state
                if (in) begin // Stop bit detected
                    state <= 3'b001; // Reset to IDLE state
                end
            end
        endcase
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule