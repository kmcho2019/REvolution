module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [1:0] state; // 2-bit binary encoded state register
reg [7:0] data; // 8-bit data register
reg [2:0] bit_count; // 3-bit counter to keep track of number of bits received

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to IDLE state
        data <= 8'b0; // Reset data register
        bit_count <= 3'b0; // Reset counter
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 2'b01; // Move to START state
                end
            end
            2'b01: begin // START state
                if (~in) begin // Start bit valid
                    state <= 2'b10; // Move to RECEIVE state
                    data[0] <= in; // Load start bit into data register
                    bit_count <= 3'b1; // Increment counter
                end else begin
                    state <= 2'b00; // Move back to IDLE state
                end
            end
            2'b10: begin // RECEIVE state
                data <= {data[6:0], in}; // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
                if (bit_count == 8) begin // 8 bits received
                    state <= 2'b11; // Move to STOP state
                end
            end
            2'b11: begin // STOP state
                if (in) begin // Stop bit correct
                    done <= 1'b1; // Set done signal high
                    state <= 2'b00; // Move back to IDLE state
                end else begin
                    state <= 2'b10; // Move back to RECEIVE state
                end
                bit_count <= 3'b0; // Reset counter
            end
        endcase
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule