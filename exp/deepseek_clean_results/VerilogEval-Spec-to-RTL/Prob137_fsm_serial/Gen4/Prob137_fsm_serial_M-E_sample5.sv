module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // States - now simpler with window concept
    typedef enum logic [1:0] {
        IDLE,       // Waiting for start bit (window closed)
        WINDOW_OPEN, // Receiving data (window open)
        VERIFY      // Checking stop bit
    } state_t;

    reg [1:0] state, next_state;
    reg [7:0] shift_reg;    // Acts as both data storage and position tracker
    reg done_reg;

    // State transition and data handling
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'b0;
            done_reg <= 0;
        end else begin
            state <= next_state;
            done_reg <= 0;  // Default to 0

            case (state)
                IDLE: begin
                    shift_reg <= 8'b0;  // Clear when window closed
                end

                WINDOW_OPEN: begin
                    // Shift in new bit (LSB first)
                    // When MSB becomes 1, we've collected all 8 bits
                    shift_reg <= {in, shift_reg[7:1]};
                end

                VERIFY: begin
                    done_reg <= in;  // Valid stop bit sets done
                end
            endcase
        end
    end

    // Next state logic - window-based transitions
    always @(*) begin
        next_state = state;  // Default to current state
        
        case (state)
            IDLE: begin
                if (!in) next_state = WINDOW_OPEN;  // Start bit opens window
            end

            WINDOW_OPEN: begin
                if (shift_reg[7]) next_state = VERIFY;  // MSB=1 means all bits received
            end

            VERIFY: begin
                // Close window if stop bit valid, otherwise wait in VERIFY
                next_state = in ? IDLE : VERIFY;
            end
        endcase
    end

    assign done = done_reg;

endmodule