module TopModule (
    input        clk,
    input        reset,   // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // State encoding
    typedef enum reg [2:0] {
        SEARCH = 3'd0,
        LOAD_DELAY = 3'd1,
        INIT_COUNT = 3'd2,
        COUNTING = 3'd3,
        DONE_STATE = 3'd4
    } state_t;

    state_t state, next_state;

    // Constants
    localparam [3:0] START_PATTERN = 4'b1101;
    localparam integer CYCLE_MAX = 999; // 1000 cycles counting from 0 to 999

    // Registers
    reg [3:0] pattern_shift;       // shift register to detect start pattern
    reg [2:0] delay_bit_cnt;       // counts loaded delay bits (0 to 4)
    reg [3:0] delay_reg;           // loaded delay value (4 bits)

    reg [9:0] cycle_counter;       // counts 0..999 cycles per tick
    reg [4:0] tick_counter;        // counts delay+1 down to 0 (5 bits to hold up to 17)

    // Sequential logic: state, counters, outputs
    always @(posedge clk) begin
        if (reset) begin
            // Reset all registers and outputs
            state <= SEARCH;
            pattern_shift <= 4'd0;
            delay_bit_cnt <= 3'd0;
            delay_reg <= 4'd0;
            cycle_counter <= 10'd0;
            tick_counter <= 5'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift in data to pattern_shift (MSB first):
                    // pattern_shift[3] is oldest bit, pattern_shift[0] is newest bit after shift
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay loading registers
                    delay_bit_cnt <= 3'd0;
                    delay_reg <= 4'd0;

                    // Clear counters and outputs
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB first: shift left and insert new data at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bit_cnt <= delay_bit_cnt + 1;

                    // Freeze pattern_shift (no further pattern detection)
                    pattern_shift <= pattern_shift;

                    // Clear outputs and counters before counting
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                end

                INIT_COUNT: begin
                    // Initialize counting: tick_counter = delay+1
                    tick_counter <= delay_reg + 1'b1;
                    cycle_counter <= 10'd0;

                    // Counting starts immediately
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Output count is delay value initially
                    count <= delay_reg;

                    // Freeze pattern_shift and delay registers
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bit_cnt <= delay_bit_cnt;
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Pattern detection ignored here, keep pattern_shift frozen
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bit_cnt <= delay_bit_cnt;

                    if (cycle_counter == CYCLE_MAX) begin
                        // End of 1000 cycles tick
                        cycle_counter <= 10'd0;

                        if (tick_counter != 0) begin
                            tick_counter <= tick_counter - 1;
                        end else begin
                            tick_counter <= 5'd0;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                        tick_counter <= tick_counter; // hold
                    end

                    // Update count output:
                    // Show remaining delay ticks for current 1000-cycle block.
                    // count = tick_counter - 1 if tick_counter > 0 else 0
                    if (tick_counter > 0)
                        count <= tick_counter[3:0] - 1;
                    else
                        count <= 4'd0;
                end

                DONE_STATE: begin
                    done <= 1'b1;
                    counting <= 1'b0;
                    count <= 4'd0;

                    // Freeze registers
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bit_cnt <= delay_bit_cnt;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                end

                default: begin
                    // Defensive fallback
                    state <= SEARCH;
                    pattern_shift <= 4'd0;
                    delay_bit_cnt <= 3'd0;
                    delay_reg <= 4'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

    // Combinational next-state logic
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                // Transition to LOAD_DELAY on detecting start pattern
                if (pattern_shift == START_PATTERN)
                    next_state = LOAD_DELAY;
                else
                    next_state = SEARCH;
            end

            LOAD_DELAY: begin
                // After loading exactly 4 bits delay, start counting
                if (delay_bit_cnt == 3'd4)
                    next_state = INIT_COUNT;
                else
                    next_state = LOAD_DELAY;
            end

            INIT_COUNT: begin
                // Immediately move to COUNTING after init
                next_state = COUNTING;
            end

            COUNTING: begin
                // When counting complete (tick_counter=0 and cycle_counter=999), move to DONE_STATE
                if ((tick_counter == 0) && (cycle_counter == CYCLE_MAX))
                    next_state = DONE_STATE;
                else
                    next_state = COUNTING;
            end

            DONE_STATE: begin
                // Wait for ack to return to SEARCH state
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = DONE_STATE;
            end

            default: next_state = SEARCH;
        endcase
    end

endmodule