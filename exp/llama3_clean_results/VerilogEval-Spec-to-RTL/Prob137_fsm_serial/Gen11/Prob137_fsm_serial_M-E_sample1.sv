module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [7:0] circular_buffer; // 8-bit circular buffer to store incoming bits
reg [2:0] pointer; // 3-bit pointer to keep track of the current position in the buffer
reg start_detected; // Flag to indicate if start bit has been detected
reg [2:0] state; // 3-bit state register (IDLE, START, RECEIVE)

always @(posedge clk) begin
    if (reset) begin
        circular_buffer <= 8'b0; // Reset circular buffer
        pointer <= 3'b0; // Reset pointer
        start_detected <= 1'b0; // Reset start detected flag
        state <= 3'b0; // Reset state (IDLE)
        done <= 1'b0; // Reset done signal
    end else begin
        case(state)
            3'b000: begin // IDLE state
                if (~in) begin // Start bit detected
                    start_detected <= 1'b1; // Set start detected flag
                    circular_buffer[0] <= in; // Store start bit in buffer
                    pointer <= 3'b1; // Increment pointer
                    state <= 3'b001; // Transition to START state
                end
            end
            3'b001: begin // START state
                if (in) begin // Stop bit detected, reset
                    start_detected <= 1'b0; // Reset start detected flag
                    state <= 3'b000; // Transition to IDLE state
                end else begin
                    circular_buffer[pointer] <= in; // Store incoming bit in buffer
                    pointer <= pointer + 1; // Increment pointer
                    if (pointer == 3'b100) begin // 8 bits received
                        state <= 3'b010; // Transition to RECEIVE state
                    end
                end
            end
            3'b010: begin // RECEIVE state
                if (in) begin // Stop bit correct
                    done <= 1'b1; // Set done signal high
                    state <= 3'b000; // Transition to IDLE state
                end else begin // Stop bit incorrect
                    state <= 3'b001; // Transition to START state
                end
            end
        endcase
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule