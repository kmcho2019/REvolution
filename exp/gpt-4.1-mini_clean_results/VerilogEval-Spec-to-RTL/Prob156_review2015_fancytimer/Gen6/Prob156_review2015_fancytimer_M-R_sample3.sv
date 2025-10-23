module TopModule (
    input        clk,
    input        reset,  // synchronous active-high reset
    input        data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input        ack
);

    // FSM states
    typedef enum logic [1:0] {
        SEARCH     = 2'd0,
        LOAD_DELAY = 2'd1,
        COUNTING   = 2'd2,
        DONE       = 2'd3
    } state_t;

    state_t state, next_state;

    // Pattern detection shift register
    reg [3:0] pattern_shift;

    // Delay register and bit counter
    reg [3:0] delay_reg;
    reg [2:0] delay_bit_count;

    // Counters for timing
    reg [9:0] cycle_counter; // counts 0..999 per tick
    reg [3:0] tick_counter;  // counts down from delay to 0

    // Pattern detected flag
    wire pattern_detected = (pattern_shift == 4'b1101);

    // Sequential state and data registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            delay_bit_count <= 3'd0;
            cycle_counter <= 10'd0;
            tick_counter <= 4'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift in new bit on pattern_shift (MSB first shift)
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_reg <= 4'd0;
                    delay_bit_count <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB first
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bit_count <= delay_bit_count + 1'b1;
                    pattern_shift <= pattern_shift; // hold pattern_shift unchanged
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                COUNTING: begin
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bit_count <= 3'd0;

                    // Cycle counter increments until 999, then wraps to 0 and tick_counter decrements
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (tick_counter != 0)
                            tick_counter <= tick_counter - 1'b1;
                        else
                            tick_counter <= 4'd0; // stay at zero
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                        tick_counter <= tick_counter;
                    end

                    count <= tick_counter;
                    counting <= 1'b1;
                    done <= 1'b0;
                end

                DONE: begin
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    delay_bit_count <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b1;
                end

                default: begin
                    // Safety default, reset all registers
                    state <= SEARCH;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    delay_bit_count <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            SEARCH: begin
                if (pattern_detected) 
                    next_state = LOAD_DELAY;
                else
                    next_state = SEARCH;
            end

            LOAD_DELAY: begin
                if (delay_bit_count == 3'd4) // 4 bits loaded, move to COUNTING
                    next_state = COUNTING;
                else
                    next_state = LOAD_DELAY;
            end

            COUNTING: begin
                // Count ticks and cycle_counter to determine when to finish
                // Finish when tick_counter=0 and cycle_counter=999 (last cycle done)
                if ((tick_counter == 0) && (cycle_counter == 10'd999))
                    next_state = DONE;
                else
                    next_state = COUNTING;
            end

            DONE: begin
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = DONE;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Initialize tick_counter at transition from LOAD_DELAY to COUNTING
    // For that, detect LOAD_DELAY->COUNTING edge and load tick_counter with delay_reg.
    reg prev_load_delay;
    always @(posedge clk) begin
        if (reset) begin
            prev_load_delay <= 1'b0;
        end else begin
            prev_load_delay <= (state == LOAD_DELAY);
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            tick_counter <= 4'd0;
        end else if ((prev_load_delay) && (state == COUNTING)) begin
            // Load tick_counter with delay_reg at start of COUNTING
            tick_counter <= delay_reg;
        end
    end

endmodule