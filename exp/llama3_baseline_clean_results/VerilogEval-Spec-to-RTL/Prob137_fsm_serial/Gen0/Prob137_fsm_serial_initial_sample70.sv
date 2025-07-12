module TopModule(
    input  clk,
    input  reset,
    input  in,
    output done
);

    // Define the states of the FSM
    enum logic [2:0] {
        IDLE,
        START_BIT,
        DATA_BITS,
        STOP_BIT
    } state, next_state;

    // Register to store the received byte
    logic [7:0] byte;

    // Counter for the number of data bits received
    logic [3:0] data_bit_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            // Reset the FSM to the idle state and clear internal state
            state <= IDLE;
            byte <= 8'b0;
            data_bit_count <= 4'b0;
        end else begin
            state <= next_state;
            // Update the received byte and data bit count based on the current state
            case (state)
                START_BIT: begin
                    // Do nothing, just transition to the next state
                end
                DATA_BITS: begin
                    // Shift in the current bit
                    byte <= {byte[6:0], in};
                    data_bit_count <= data_bit_count + 1'b1;
                end
                STOP_BIT: begin
                    // Do nothing, just transition to the next state
                end
                default: begin
                    // Do nothing for other states
                end
            endcase
        end
    end

    always_comb begin
        // Determine the next state based on the current state and input
        next_state = state;
        done = 1'b0; // Default done signal to low

        case (state)
            IDLE: begin
                if (!in) begin
                    // Start bit detected, transition to start bit state
                    next_state = START_BIT;
                end
            end
            START_BIT: begin
                // Transition to data bits state
                next_state = DATA_BITS;
            end
            DATA_BITS: begin
                if (data_bit_count == 8) begin
                    // All data bits received, transition to stop bit state
                    next_state = STOP_BIT;
                end
            end
            STOP_BIT: begin
                if (in) begin
                    // Stop bit detected, signal done and transition to idle state
                    done = 1'b1;
                    next_state = IDLE;
                end else begin
                    // Stop bit not detected, stay in stop bit state until stop bit is detected
                end
            end
            default: begin
                // Do nothing for other states
            end
        endcase
    end

endmodule