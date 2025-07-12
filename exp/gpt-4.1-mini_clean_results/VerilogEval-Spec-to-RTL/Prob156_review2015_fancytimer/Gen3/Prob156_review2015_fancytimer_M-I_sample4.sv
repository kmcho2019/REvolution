module TopModule (
    input        clk,
    input        reset,  // synchronous active-high reset
    input        data,
    output reg [3:0] count,
    output reg       counting,
    output reg       done,
    input        ack
);

    typedef enum logic [1:0] {
        IDLE       = 2'd0, // Searching for pattern 1101
        LOAD_DELAY = 2'd1, // Loading 4 delay bits MSB first
        COUNTING   = 2'd2, // Counting timer cycles
        DONE       = 2'd3  // Timer done, waiting for ack
    } state_t;

    state_t state, next_state;

    // Pattern detection shift register (4 bits)
    reg [3:0] pattern_shift;

    // Delay bits register and count of loaded bits
    reg [3:0] delay_reg;
    reg [2:0] delay_bit_count; // from 0 to 4

    // Timer counters
    reg [11:0] cycle_counter;   // counts 0..999 clock cycles
    reg [4:0]  tick_counter;    // counts delay+1 down to 0; needs 5 bits to store max 17 (15+1=16)

    // Detect start pattern "1101"
    wire pattern_match = (pattern_shift == 4'b1101);

    // FSM combinational next-state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (pattern_match)
                    next_state = LOAD_DELAY;
            end
            LOAD_DELAY: begin
                if (delay_bit_count == 4)
                    next_state = COUNTING;
            end
            COUNTING: begin
                // Transition to DONE immediately when last tick completes
                // i.e., when tick_counter == 0 and cycle_counter == 999 means counting complete.
                // But to fix off-by-one, we will move to DONE as soon as tick_counter reaches zero after decrement.
                if ((tick_counter == 0) && (cycle_counter == 12'd999))
                    next_state = DONE;
            end
            DONE: begin
                if (ack)
                    next_state = IDLE;
            end
        endcase
    end

    // Sequential state and registers update
    always @(posedge clk) begin
        if (reset) begin
            // Reset all registers
            state <= IDLE;
            pattern_shift <= 4'b0000;
            delay_reg <= 4'b0000;
            delay_bit_count <= 3'd0;
            cycle_counter <= 12'd0;
            tick_counter <= 5'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    // Shift pattern_shift only in IDLE
                    pattern_shift <= {pattern_shift[2:0], data};
                    // Clear delay loading registers and counters
                    delay_bit_count <= 3'd0;
                    delay_reg <= 4'b0000;
                    cycle_counter <= 12'd0;
                    tick_counter <= 5'd0;

                    // Outputs inactive
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB first:
                    // Input is serial MSB first, so shift left and insert data at LSB.
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bit_count <= delay_bit_count + 1;

                    // Freeze pattern_shift (ignore data) during delay loading
                    pattern_shift <= pattern_shift;

                    // Outputs inactive
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                COUNTING: begin
                    // Freeze pattern_shift during counting
                    pattern_shift <= pattern_shift;

                    counting <= 1'b1;
                    done <= 1'b0;

                    // cycle_counter increments 0..999
                    if (cycle_counter == 12'd999) begin
                        cycle_counter <= 12'd0;
                        // Decrement tick_counter if greater than zero
                        if (tick_counter > 0)
                            tick_counter <= tick_counter - 1;
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end

                    // Output remaining count = tick_counter - 1 (for tick_counter>0), else 0
                    // This reflects that tick_counter counts delay+1 down to 0.
                    if (tick_counter == 0)
                        count <= 4'd0;
                    else
                        count <= tick_counter - 1;
                end

                DONE: begin
                    // Freeze pattern_shift
                    pattern_shift <= pattern_shift;

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;

                    // Clear delay loading counters and cycle counters - no counting
                    delay_bit_count <= 3'd0;
                    cycle_counter <= 12'd0;
                    tick_counter <= 5'd0;
                end

                default: begin
                    // Safety fallback: reset state machine
                    state <= IDLE;
                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'b0000;
                    delay_bit_count <= 3'd0;
                    cycle_counter <= 12'd0;
                    tick_counter <= 5'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase

            // Latch tick_counter at transition from LOAD_DELAY to COUNTING
            if ((state == LOAD_DELAY) && (next_state == COUNTING)) begin
                // tick_counter = delay_reg + 1 (needs 5 bits)
                tick_counter <= {1'b0, delay_reg} + 5'd1;
                cycle_counter <= 12'd0;
            end
        end
    end

endmodule