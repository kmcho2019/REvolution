module TopModule (
    input  clk,
    input  reset,  // synchronous active high
    input  data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input  ack
);

    // States of FSM
    typedef enum reg [1:0] {
        SEARCH     = 2'b00,
        LOAD_DELAY = 2'b01,
        COUNTING   = 2'b10,
        DONE       = 2'b11
    } state_t;

    state_t state, next_state;

    // Pattern detection shift register, only updated in SEARCH
    reg [3:0] pattern_shift;

    // Delay register, to hold 4 delay bits, MSB-first
    reg [3:0] delay;

    // Count of delay bits loaded in LOAD_DELAY
    reg [2:0] delay_bits_loaded;  // up to 4

    // Counting state counters:
    // step_counter counts down from delay to 0 (delay steps)
    reg [3:0] step_counter;

    // cycle_counter counts clock cycles inside each 1000-cycle interval
    // counts 0..999
    reg [9:0] cycle_counter;

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                if (delay_bits_loaded == 4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // When step_counter == 0 and cycle_counter == 999, done counting
                if ((step_counter == 0) && (cycle_counter == 10'd999))
                    next_state = DONE;
            end

            DONE: begin
                if (ack)
                    next_state = SEARCH;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            // Reset all state and registers
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay <= 4'b0000;
            delay_bits_loaded <= 0;
            step_counter <= 0;
            cycle_counter <= 0;

            count <= 4'b0000;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Clear outputs
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000; // don't-care zero

                    // Shift pattern register left and insert new data bit at LSB
                    // To detect 1101 MSB first, shift left and input data at LSB
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay loading info
                    delay_bits_loaded <= 0;
                    delay <= 4'b0000;

                    // Clear counting counters
                    step_counter <= 0;
                    cycle_counter <= 0;
                end

                LOAD_DELAY: begin
                    // Still no counting or done
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000; // don't-care zero

                    // Shift in delay bits MSB first:
                    // Shift delay right by 1 bit and put new data at MSB:
                    // On first bit loaded, delay[3] = data, second bit loaded delay[2], etc.
                    delay <= {data, delay[3:1]};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;

                    // Keep pattern_shift unchanged here (ignore data for pattern)
                    pattern_shift <= pattern_shift;
                end

                COUNTING: begin
                    done <= 1'b0;
                    counting <= 1'b1;

                    // Hold pattern_shift and delay stable (no changes)
                    pattern_shift <= pattern_shift;

                    // Counting logic
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 0;

                        if (step_counter != 0) begin
                            step_counter <= step_counter - 1'b1;
                        end
                        // else step_counter == 0, will move to DONE in next_state logic
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end

                    // Output count equals step_counter, stable for each 1000 cycles
                    count <= step_counter;
                end

                DONE: begin
                    done <= 1'b1;
                    counting <= 1'b0;
                    count <= 4'b0000; // don't-care zero

                    // Hold pattern_shift and delay stable
                    pattern_shift <= pattern_shift;

                    // Clear counters on ack, handled below
                end

                default: begin
                    // Default safe state
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                end
            endcase

            // Initialize counting parameters on transition LOAD_DELAY->COUNTING
            if (state == LOAD_DELAY && next_state == COUNTING) begin
                // Load step_counter with delay value
                step_counter <= delay;
                cycle_counter <= 0;
            end

            // On DONE->SEARCH transition, clear pattern_shift and other registers
            if (state == DONE && next_state == SEARCH) begin
                pattern_shift <= 4'b0000;
                delay <= 4'b0000;
                delay_bits_loaded <= 0;
                step_counter <= 0;
                cycle_counter <= 0;

                count <= 4'b0000;
                counting <= 1'b0;
                done <= 1'b0;
            end
        end
    end

endmodule