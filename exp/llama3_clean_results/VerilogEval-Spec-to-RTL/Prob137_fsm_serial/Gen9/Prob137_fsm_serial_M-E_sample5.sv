module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [8:0] shift_reg; // Shift register to store received bits
reg [3:0] bit_counter; // Counter to keep track of received bits
reg [1:0] state; // State machine state (0: IDLE, 1: START_BIT, 2: RECEIVE_DATA, 3: STOP_BIT)

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 9'b0; // Reset shift register
        bit_counter <= 4'b0; // Reset counter
        state <= 2'b00; // Reset state machine state
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (~in) begin // Start bit detected
                    shift_reg <= {8'b0, in}; // Shift in start bit
                    bit_counter <= 4'b1; // Increment counter
                    state <= 2'b01; // Transition to START_BIT state
                end
            end
            2'b01: begin // START_BIT state
                shift_reg <= {shift_reg[7:0], in}; // Shift in new bit
                bit_counter <= bit_counter + 1; // Increment counter
                state <= 2'b10; // Transition to RECEIVE_DATA state
            end
            2'b10: begin // RECEIVE_DATA state
                shift_reg <= {shift_reg[7:0], in}; // Shift in new bit
                bit_counter <= bit_counter + 1; // Increment counter
                if (bit_counter == 9) begin // 9 bits received
                    state <= 2'b11; // Transition to STOP_BIT state
                end
            end
            2'b11: begin // STOP_BIT state
                if (in) begin // Stop bit correct
                    done <= 1'b1; // Set done signal high
                    shift_reg <= 9'b0; // Reset shift register
                    bit_counter <= 4'b0; // Reset counter
                    state <= 2'b00; // Transition to IDLE state
                end else begin // Stop bit incorrect
                    if (in) begin // Stop bit detected
                        shift_reg <= 9'b0; // Reset shift register
                        bit_counter <= 4'b0; // Reset counter
                        state <= 2'b00; // Transition to IDLE state
                    end
                end
            end
        endcase
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule