module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output reg  shift_ena,
    output reg  counting,
    output reg  done
);

    // States encoding (3 bits)
    typedef enum logic [2:0] {
        IDLE       = 3'd0, // Searching for pattern
        SHIFT_DELAY= 3'd1, // Shift 4 delay bits
        WAIT_COUNT = 3'd2, // Wait for done_counting
        WAIT_ACK   = 3'd3  // Assert done, wait for ack
    } state_t;

    state_t state, next_state;

    reg [3:0] pattern_shift_reg; // Shift register for pattern detection
    reg [2:0] shift_counter;     // Count 0 to 3 for 4 cycles shifting delay bits

    // Sequential logic: state, pattern_shift_reg, shift_counter updates
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift_reg <= 4'b0000;
            shift_counter <= 3'd0;
        end else begin
            // Shift in data every clock to detect pattern when IDLE
            pattern_shift_reg <= {pattern_shift_reg[2:0], data};

            state <= next_state;

            if (state == SHIFT_DELAY)
                shift_counter <= shift_counter + 3'd1;
            else
                shift_counter <= 3'd0;
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                // Check pattern 1101 on shift register: MSB first pattern is bits [3:0]
                // pattern_shift_reg holds last 4 bits shifted in with LSB newest (due to concatenation)
                // pattern 1101 binary: 4'b1101 == decimal 13
                if (pattern_shift_reg == 4'b1101)
                    next_state = SHIFT_DELAY;
                else
                    next_state = IDLE;
            end
            SHIFT_DELAY: begin
                // After shifting 4 bits (count from 0 to 3), move to WAIT_COUNT
                if (shift_counter == 3'd3)
                    next_state = WAIT_COUNT;
                else
                    next_state = SHIFT_DELAY;
            end
            WAIT_COUNT: begin
                // Wait until done_counting asserted
                if (done_counting)
                    next_state = WAIT_ACK;
                else
                    next_state = WAIT_COUNT;
            end
            WAIT_ACK: begin
                // Assert done, wait for ack to return to IDLE
                if (ack)
                    next_state = IDLE;
                else
                    next_state = WAIT_ACK;
            end
            default: next_state = IDLE;
        endcase
    end

    // Outputs logic (combinational)
    always @(*) begin
        // shift_ena asserted only in SHIFT_DELAY while shift_counter < 4
        shift_ena = (state == SHIFT_DELAY);

        // counting asserted only in WAIT_COUNT state
        counting = (state == WAIT_COUNT);

        // done asserted only in WAIT_ACK state
        done = (state == WAIT_ACK);
    end

endmodule