module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [8:0] data_reg; // Register to store the received bits
reg [3:0] bit_count; // Counter to keep track of the number of bits received
reg start_detected; // Flag to indicate start bit detection
reg wait_stop; // Flag to wait for stop bit
reg [1:0] state; // State machine state (0: IDLE, 1: RECEIVE, 2: WAIT_STOP)

always @(posedge clk) begin
    if (reset) begin
        data_reg <= 9'b0; // Reset data register
        bit_count <= 4'b0; // Reset counter
        start_detected <= 1'b0; // Reset start bit detection flag
        wait_stop <= 1'b0; // Reset wait stop flag
        state <= 2'b00; // Reset state machine state
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (~in) begin // Start bit detected
                    start_detected <= 1'b1; // Set start bit detection flag
                    data_reg <= {8'b0, in}; // Load start bit into data register
                    bit_count <= 4'b1; // Increment counter
                    state <= 2'b01; // Transition to RECEIVE state
                end
            end
            2'b01: begin // RECEIVE state
                data_reg <= {data_reg[7:0], in}; // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
                if (bit_count == 9) begin // 9 bits received
                    if (in) begin // Stop bit correct
                        done <= 1'b1; // Set done signal high
                        start_detected <= 1'b0; // Reset start bit detection flag
                        wait_stop <= 1'b0; // Reset wait stop flag
                        state <= 2'b00; // Transition to IDLE state
                    end else begin // Stop bit incorrect
                        wait_stop <= 1'b1; // Set wait stop flag
                        start_detected <= 1'b0; // Reset start bit detection flag
                        state <= 2'b10; // Transition to WAIT_STOP state
                    end
                    bit_count <= 4'b0; // Reset counter
                end
            end
            2'b10: begin // WAIT_STOP state
                if (in) begin // Stop bit detected
                    wait_stop <= 1'b0; // Reset wait stop flag
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