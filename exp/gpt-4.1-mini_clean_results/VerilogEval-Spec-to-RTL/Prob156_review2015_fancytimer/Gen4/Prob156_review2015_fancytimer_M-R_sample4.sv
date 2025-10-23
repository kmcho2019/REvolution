module TopModule (
    input        clk,
    input        reset,  // synchronous active-high reset
    input        data,
    output reg [3:0] count,
    output reg       counting,
    output reg       done,
    input        ack
);

    // State encoding (one-hot style for clarity)
    typedef enum reg [1:0] {
        IDLE       = 2'd0,
        LOAD_DELAY = 2'd1,
        COUNTING   = 2'd2,
        DONE       = 2'd3
    } state_t;

    reg [1:0] state, next_state;

    // Shift register for pattern detection (4 bits)
    reg [3:0] pattern_shift;

    // Delay register for 4 bits MSB first and bit counter
    reg [3:0] delay_reg;
    reg [2:0] delay_bit_count;

    // Timer counters
    reg [11:0] cycle_counter;   // counts 0..999 clock cycles per tick
    reg [4:0] tick_counter;     // counts ticks remaining (delay+1 down to 0)

    wire pattern_detected = (pattern_shift == 4'b1101);

    // Next state logic combinational
    always @(*) begin
        case (state)
            IDLE:
                if (pattern_detected)
                    next_state = LOAD_DELAY;
                else
                    next_state = IDLE;

            LOAD_DELAY:
                if (delay_bit_count == 4)
                    next_state = COUNTING;
                else
                    next_state = LOAD_DELAY;

            COUNTING:
                // Transition to DONE at end of last cycle of last tick
                if (tick_counter == 0 && cycle_counter == 12'd999)
                    next_state = DONE;
                else
                    next_state = COUNTING;

            DONE:
                if (ack)
                    next_state = IDLE;
                else
                    next_state = DONE;

            default:
                next_state = IDLE;
        endcase
    end

    // Sequential logic: state register, counters, and pattern shift register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0000;
            delay_reg <= 4'b0000;
            delay_bit_count <= 3'd0;
            cycle_counter <= 12'd0;
            tick_counter <= 5'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    // Shift pattern register only in IDLE to detect pattern
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear counters and delay info
                    delay_reg <= 4'b0000;
                    delay_bit_count <= 3'd0;
                    cycle_counter <= 12'd0;
                    tick_counter <= 5'd0;
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB first: shift left, insert data at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bit_count <= delay_bit_count + 1;

                    // Keep pattern shift unchanged during delay load
                    pattern_shift <= pattern_shift;

                    cycle_counter <= 12'd0;
                    tick_counter <= 5'd0;
                end

                COUNTING: begin
                    pattern_shift <= pattern_shift; // freeze pattern

                    // Increment cycle_counter each clock
                    if (cycle_counter == 12'd999) begin
                        cycle_counter <= 12'd0;
                        if (tick_counter > 0)
                            tick_counter <= tick_counter - 1;
                        // else tick_counter stays 0
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end

                    // delay_reg, delay_bit_count unchanged
                end

                DONE: begin
                    pattern_shift <= pattern_shift; // freeze pattern

                    // Clear delay and counters in DONE state
                    delay_reg <= delay_reg;
                    delay_bit_count <= 3'd0;
                    cycle_counter <= 12'd0;
                    tick_counter <= 5'd0;
                end

                default: begin
                    // Safety: reset all
                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'b0000;
                    delay_bit_count <= 3'd0;
                    cycle_counter <= 12'd0;
                    tick_counter <= 5'd0;
                end
            endcase

            // Load tick_counter with delay+1 at transition LOAD_DELAY->COUNTING
            if (state == LOAD_DELAY && next_state == COUNTING) begin
                tick_counter <= delay_reg + 5'd1; // 5-bit to hold max 16
                cycle_counter <= 12'd0;
            end
        end
    end

    // Output logic combinational
    always @(*) begin
        // Defaults
        counting = 1'b0;
        done = 1'b0;
        count = 4'bxxxx; // don't care outside counting if you want

        case (state)
            IDLE: begin
                // count don't care, counting and done low
                counting = 1'b0;
                done = 1'b0;
                count = 4'bxxxx;
            end

            LOAD_DELAY: begin
                counting = 1'b0;
                done = 1'b0;
                count = 4'bxxxx;
            end

            COUNTING: begin
                counting = 1'b1;
                done = 1'b0;

                // count output: remaining time stable for 1000 cycles per count value
                // We show tick_counter-1 when tick_counter>0, else 0 when tick_counter==0
                // This matches the spec's requirement.
                if (tick_counter == 0)
                    count = 4'd0;
                else
                    count = tick_counter - 1;
            end

            DONE: begin
                counting = 1'b0;
                done = 1'b1;
                count = 4'bxxxx; // don't care in DONE
            end

            default: begin
                counting = 1'b0;
                done = 1'b0;
                count = 4'bxxxx;
            end
        endcase
    end

endmodule