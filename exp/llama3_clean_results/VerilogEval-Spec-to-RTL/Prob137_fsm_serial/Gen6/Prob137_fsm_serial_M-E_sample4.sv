module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [7:0] data_register; // 8-bit register to store incoming data bits
reg [2:0] bit_count; // 3-bit counter to track number of bits received
reg start_bit; // Flag to indicate start bit reception
reg stop_bit; // Flag to indicate stop bit reception
reg state; // Flag to indicate current state (IDLE = 0, START = 1, RECEIVE = 2, STOP = 3)

always @(posedge clk) begin
    if (reset) begin
        data_register <= 8'b0; // Reset data register
        bit_count <= 3'b0; // Reset counter
        start_bit <= 1'b0; // Reset start bit flag
        stop_bit <= 1'b0; // Reset stop bit flag
        state <= 1'b0; // Reset state to IDLE
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            1'b0: begin // IDLE state
                if (~in) begin // Start bit detected
                    start_bit <= 1'b1; // Set start bit flag
                    state <= 1'b1; // Move to START state
                end
            end
            1'b1: begin // START state
                if (start_bit) begin // Start bit verified
                    data_register <= 8'b0; // Reset data register
                    bit_count <= 3'b1; // Increment counter
                    state <= 1'b2; // Move to RECEIVE state
                end
            end
            1'b2: begin // RECEIVE state
                data_register <= {data_register[6:0], in}; // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
                if (bit_count == 3'b1000) begin // 8 bits received
                    state <= 1'b3; // Move to STOP state
                end
            end
            1'b3: begin // STOP state
                if (in) begin // Stop bit detected
                    stop_bit <= 1'b1; // Set stop bit flag
                    done <= 1'b1; // Set done signal
                    state <= 1'b0; // Move back to IDLE state
                end else begin // Stop bit not detected
                    state <= 1'b0; // Move back to IDLE state
                end
            end
        endcase
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule