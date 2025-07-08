module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input  ack
);

    // FSM states
    localparam STATE_SEARCH      = 3'd0;
    localparam STATE_SHIFT_DELAY = 3'd1;
    localparam STATE_COUNT       = 3'd2;
    localparam STATE_DONE        = 3'd3;

    reg [2:0] state, next_state;

    // Shift register for pattern detection and delay input
    reg [3:0] pattern_shift; // holds last 4 bits for pattern detection
    reg [3:0] delay;

    // Counters for timing
    reg [9:0] cycle_counter;   // counts up to 1000 cycles (0..999)
    reg [3:0] delay_countdown; // counts down from delay to 0

    // Signals for internal control
    reg pattern_detected;

    // Synchronous logic
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_SEARCH;
            pattern_shift <= 4'b0;
            delay <= 4'b0;
            cycle_counter <= 10'd0;
            delay_countdown <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0000;
        end else begin
            state <= next_state;

            case(state)
                STATE_SEARCH: begin
                    // Shift in data to pattern_shift for detection
                    pattern_shift <= {pattern_shift[2:0], data};

                    // No outputs asserted
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                end

                STATE_SHIFT_DELAY: begin
                    // Shift in 4 bits MSB first into delay
                    // We reuse pattern_shift as a shift register here for delay bits as well
                    pattern_shift <= {pattern_shift[2:0], data};
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                end

                STATE_COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    count <= delay_countdown;

                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (delay_countdown != 4'd0)
                            delay_countdown <= delay_countdown - 1;
                        else
                            delay_countdown <= 0; // stay at 0
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                end

                STATE_DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0000; // don't care, set to 0
                end

                default: begin
                    // Default safe values
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                end
            endcase
        end
    end

    // Next state logic and control
    always @(*) begin
        next_state = state;

        case(state)
            STATE_SEARCH: begin
                // Check if pattern_shift == 1101 (binary)
                if (pattern_shift == 4'b1101) begin
                    next_state = STATE_SHIFT_DELAY;
                end else begin
                    next_state = STATE_SEARCH;
                end
            end

            STATE_SHIFT_DELAY: begin
                // We must shift in 4 bits total; we get 1 bit per clock in pattern_shift
                // Use a counter to know when 4 bits have been shifted in after pattern detected

                // Count how many delay bits shifted in (use a local counter)
                // Because pattern_shift is overwritten every cycle, use a separate shift count.

                // We will implement shift count as a reg. Implemented below.

                if (delay_shift_count == 4) begin
                    next_state = STATE_COUNT;
                end else begin
                    next_state = STATE_SHIFT_DELAY;
                end
            end

            STATE_COUNT: begin
                // Count cycles and delay_countdown until delay_countdown reaches 0 and cycle_counter reaches 999
                if ((delay_countdown == 4'd0) && (cycle_counter == 10'd999)) begin
                    next_state = STATE_DONE;
                end else begin
                    next_state = STATE_COUNT;
                end
            end

            STATE_DONE: begin
                // Wait for ack=1 to return to SEARCH
                if (ack) begin
                    next_state = STATE_SEARCH;
                end else begin
                    next_state = STATE_DONE;
                end
            end

            default: next_state = STATE_SEARCH;
        endcase
    end

    // Additional logic: delay_shift_count and delay register update
    reg [2:0] delay_shift_count; // counts how many delay bits shifted in (0 to 4)

    always @(posedge clk) begin
        if (reset) begin
            delay_shift_count <= 3'd0;
            delay <= 4'b0;
        end else begin
            if (state == STATE_SHIFT_DELAY) begin
                delay_shift_count <= delay_shift_count + 1;

                // Shift delay bits in MSB first
                // On each clock, shift in the data bit to LSB end of delay
                // Because MSB first: we shift left, insert new bit at LSB?

                // We want to shift bits MSB first:
                // On first bit, delay[3] = data
                // On second bit, delay[2] = data
                // So implement shift left by 1, insert data at LSB

                delay <= {delay[2:0], data};

            end else begin
                delay_shift_count <= 3'd0;
            end
        end
    end

    // Initialize delay_countdown and cycle_counter at the start of COUNT state
    always @(posedge clk) begin
        if (reset) begin
            delay_countdown <= 4'd0;
            cycle_counter <= 10'd0;
        end else begin
            if ((state == STATE_SHIFT_DELAY) && (delay_shift_count == 3'd4)) begin
                // After shifting in delay bits, initialize delay_countdown and cycle_counter
                delay_countdown <= delay;
                cycle_counter <= 10'd0;
            end else if (state == STATE_COUNT) begin
                // Counting handled in main synchronous block above
            end else if (state != STATE_COUNT) begin
                // Reset counters when not counting
                delay_countdown <= delay_countdown;
                cycle_counter <= cycle_counter;
            end
        end
    end

endmodule