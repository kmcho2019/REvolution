module TopModule (
    input        clk,
    input        reset,  // synchronous active-high reset
    input        data,
    output reg [3:0] count,
    output reg       counting,
    output reg       done,
    input        ack
);

    // FSM States
    typedef enum logic [1:0] {
        IDLE       = 2'd0, // Searching for pattern 1101
        LOAD_DELAY = 2'd1, // Shifting in 4 delay bits MSB first
        COUNTING   = 2'd2, // Counting timer cycles
        DONE       = 2'd3  // Timer done, wait for ack
    } state_t;

    state_t state, next_state;

    // Pattern detection shift register
    reg [3:0] pattern_shift;

    // Delay input register
    reg [3:0] delay_reg;
    reg [2:0] delay_bit_count; // counts 0 to 4 bits shifted

    // Timer counters
    reg [11:0] cycle_counter;     // Counts clock cycles 0..999
    reg [3:0]  tick_counter;      // Counts down from delay to 0

    // Detect start pattern "1101"
    wire pattern_match = (pattern_shift == 4'b1101);

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (pattern_match)
                    next_state = LOAD_DELAY;
            end
            LOAD_DELAY: begin
                if (delay_bit_count == 4)
                    next_state = COUNTING;
            end
            COUNTING: begin
                // Transition to DONE after completing all ticks and cycles
                // Done when tick_counter == 0 and cycle_counter == 999 (end of last 1000-cycle block)
                if ((tick_counter == 0) && (cycle_counter == 12'd999))
                    next_state = DONE;
            end
            DONE: begin
                if (ack)
                    next_state = IDLE;
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            // Reset all registers
            state <= IDLE;
            pattern_shift <= 4'b0000;
            delay_reg <= 4'b0000;
            delay_bit_count <= 3'd0;
            cycle_counter <= 12'd0;
            tick_counter <= 4'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    // Shift in pattern bits continuously on every clock
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay registers and counters
                    delay_bit_count <= 3'd0;
                    delay_reg <= 4'b0000;

                    cycle_counter <= 12'd0;
                    tick_counter <= 4'd0;

                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB first:
                    // Shift left by 1 and insert new bit at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bit_count <= delay_bit_count + 1;

                    // Outputs inactive during delay load
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;

                    // Do not change pattern_shift during LOAD_DELAY
                    pattern_shift <= pattern_shift;
                end

                COUNTING: begin
                    // Hold pattern detection inactive during counting
                    pattern_shift <= pattern_shift;

                    done <= 1'b0;
                    counting <= 1'b1;

                    // Output current remaining tick count
                    count <= tick_counter;

                    // Increment cycle counter
                    if (cycle_counter == 12'd999) begin
                        cycle_counter <= 12'd0;
                        if (tick_counter != 0)
                            tick_counter <= tick_counter - 1;
                        // else tick_counter == 0: counting done, transition handled in next_state
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                end

                DONE: begin
                    // Hold outputs accordingly
                    done <= 1'b1;
                    counting <= 1'b0;
                    count <= 4'd0;

                    // Hold pattern_shift constant
                    pattern_shift <= pattern_shift;

                    // Clear delay_bit_count and counters until ack
                    delay_bit_count <= 3'd0;
                    delay_reg <= delay_reg;
                    cycle_counter <= 12'd0;
                    tick_counter <= 4'd0;
                end

                default: begin
                    // Safety fallback: reset all
                    state <= IDLE;
                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'b0000;
                    delay_bit_count <= 3'd0;
                    cycle_counter <= 12'd0;
                    tick_counter <= 4'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase

            // Latch tick_counter at the transition from LOAD_DELAY to COUNTING
            if (state == LOAD_DELAY && next_state == COUNTING) begin
                // Initialize tick_counter = delay_reg (loaded delay) + 1
                tick_counter <= delay_reg + 1;
                cycle_counter <= 12'd0;
            end
        end
    end

endmodule