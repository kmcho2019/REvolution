module TopModule (
    input        clk,
    input        reset,   // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // States
    typedef enum logic [1:0] {
        SEARCH = 2'b00,
        LOAD_DELAY = 2'b01,
        COUNTING = 2'b10,
        DONE = 2'b11
    } state_t;

    state_t state, next_state;

    // Pattern detection shift register (4 bits)
    reg [3:0] pattern_shift;

    // Delay register (loaded after pattern detected)
    reg [3:0] delay;

    // Counter for 1000 clock cycles
    reg [9:0] cycle_counter; // Enough for counting to 1000 (0 to 999)

    // Remaining delay units (counts down from delay to 0)
    reg [3:0] remaining_delay;

    // Counter for how many bits loaded into delay (0 to 3)
    reg [2:0] delay_bits_loaded;

    // Sequential logic: state transitions and data handling
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay <= 4'b0000;
            delay_bits_loaded <= 0;
            cycle_counter <= 0;
            remaining_delay <= 0;
            count <= 4'bxxxx; // don't care
            counting <= 0;
            done <= 0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift in new data bit into pattern_shift (left shift, MSB at left)
                    pattern_shift <= {pattern_shift[2:0], data};
                    counting <= 0;
                    done <= 0;
                    count <= 4'bxxxx;

                    if (next_state == LOAD_DELAY) begin
                        // Start loading delay bits
                        delay <= 4'b0000;
                        delay_bits_loaded <= 0;
                    end
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB first
                    delay <= {delay[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;
                    counting <= 0;
                    done <= 0;
                    count <= 4'bxxxx;
                end

                COUNTING: begin
                    counting <= 1;
                    done <= 0;

                    // cycle_counter counts 0 to 999
                    if (cycle_counter == 999) begin
                        cycle_counter <= 0;
                        if (remaining_delay != 0)
                            remaining_delay <= remaining_delay - 1;
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end

                    // Output remaining_delay on count
                    count <= remaining_delay;
                end

                DONE: begin
                    counting <= 0;
                    done <= 1;
                    count <= 4'bxxxx;
                    // wait for ack=1, handled in next_state logic
                end

                default: begin
                    counting <= 0;
                    done <= 0;
                    count <= 4'bxxxx;
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                // When pattern_shift == 1101 (binary 4'b1101), start load delay
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                // After loading 4 bits, start counting
                if (delay_bits_loaded == 4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // When remaining_delay is 0 and we have completed the last 1000 cycles
                if ((remaining_delay == 0) && (cycle_counter == 999))
                    next_state = DONE;
            end

            DONE: begin
                // Wait for ack to return to SEARCH
                if (ack)
                    next_state = SEARCH;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Initialize remaining_delay and cycle_counter on transition to COUNTING
    // This can be done with an always block sensitive to state changes or included in sequential block.
    // We'll do it in sequential block on state transition.
    reg state_was_counting;

    always @(posedge clk) begin
        if (reset) begin
            state_was_counting <= 0;
        end else begin
            state_was_counting <= (state == COUNTING);
            if (state == LOAD_DELAY && next_state == COUNTING) begin
                // Load remaining_delay with delay input
                remaining_delay <= delay;
                cycle_counter <= 0;
            end
        end
    end

endmodule