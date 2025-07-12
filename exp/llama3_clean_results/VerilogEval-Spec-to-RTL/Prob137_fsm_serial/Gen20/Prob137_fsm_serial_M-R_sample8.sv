module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] state; // 3-bit state register
reg [7:0] data; // 8-bit data register
reg [3:0] bit_count; // Counter to keep track of number of bits received
reg stop_bit; // Flag to indicate stop bit

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b001; // Reset to IDLE state
        data <= 8'b0; // Reset data register
        bit_count <= 4'b0; // Reset counter
        stop_bit <= 1'b0; // Reset stop bit flag
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            3'b001: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 3'b010; // Move to RECEIVE state
                    bit_count <= 4'b1; // Increment counter
                end
            end
            3'b010: begin // RECEIVE state
                data <= {data[6:0], in}; // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
                if (bit_count == 9) begin // 9 bits received
                    stop_bit <= in; // Check stop bit
                    if (in) begin // Stop bit correct
                        state <= 3'b001; // Move back to IDLE state
                    end else begin // Stop bit incorrect
                        state <= 3'b100; // Move to ERROR state
                    end
                    bit_count <= 4'b0; // Reset counter
                end
            end
            3'b100: begin // ERROR state
                if (in) begin // Stop bit detected
                    state <= 3'b001; // Move back to IDLE state
                end
            end
        endcase
    end
end

assign done = (state == 3'b001) && (bit_count == 0) && stop_bit;

endmodule