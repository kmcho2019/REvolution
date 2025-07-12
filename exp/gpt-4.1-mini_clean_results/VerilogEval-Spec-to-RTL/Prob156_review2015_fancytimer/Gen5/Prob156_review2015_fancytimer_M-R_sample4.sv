module TopModule (
    input        clk,
    input        reset,  // synchronous active-high reset
    input        data,
    output reg [3:0] count,
    output      counting,
    output      done,
    input        ack
);

    // One-hot states
    localparam SEARCH     = 4'b0001;
    localparam LOAD_DELAY = 4'b0010;
    localparam COUNTING   = 4'b0100;
    localparam DONE       = 4'b1000;

    reg [3:0] state, next_state;

    // Shift register for pattern detection (only updated in SEARCH)
    reg [3:0] pattern_shift, pattern_shift_next;

    // Delay shift register (4 bits)
    reg [3:0] delay_reg, delay_reg_next;
    reg [2:0] delay_bit_count, delay_bit_count_next;

    // Counters for timing
    reg [9:0] cycle_counter, cycle_counter_next; // counts 0..999 cycles per tick
    reg [3:0] tick_counter, tick_counter_next;   // counts remaining ticks, from delay down to 0

    // Output combinational signals
    reg counting_reg, done_reg;

    // Pattern detection
    wire pattern_match = (pattern_shift == 4'b1101);

    // Output assignments
    assign counting = counting_reg;
    assign done = done_reg;

    // Next state and combinational logic
    always @(*) begin
        // Default next-state and signals - hold current values
        next_state = state;
        pattern_shift_next = pattern_shift;
        delay_reg_next = delay_reg;
        delay_bit_count_next = delay_bit_count;
        cycle_counter_next = cycle_counter;
        tick_counter_next = tick_counter;

        counting_reg = 1'b0;
        done_reg = 1'b0;
        count = 4'd0;

        case (state)
            SEARCH: begin
                // Shift in new data bit at LSB, shift left for MSB-first pattern
                pattern_shift_next = {pattern_shift[2:0], data};
                delay_bit_count_next = 3'd0;
                delay_reg_next = 4'd0;
                cycle_counter_next = 10'd0;
                tick_counter_next = 4'd0;

                counting_reg = 1'b0;
                done_reg = 1'b0;

                // Transition when pattern detected
                if (pattern_match)
                    next_state = LOAD_DELAY;
                else
                    next_state = SEARCH;
            end

            LOAD_DELAY: begin
                // Shift in delay bits MSB first: shift left, input as LSB
                delay_reg_next = {delay_reg[2:0], data};
                delay_bit_count_next = delay_bit_count + 1'b1;

                counting_reg = 1'b0;
                done_reg = 1'b0;

                // When done loading 4 bits, move to COUNTING
                if (delay_bit_count == 3'd3) begin
                    next_state = COUNTING;
                    // Initialize counters in COUNTING state (see below)
                end else begin
                    next_state = LOAD_DELAY;
                end

                pattern_shift_next = pattern_shift; // hold pattern_shift in LOAD_DELAY
                cycle_counter_next = 10'd0;
                tick_counter_next = 4'd0;
            end

            COUNTING: begin
                counting_reg = 1'b1;
                done_reg = 1'b0;
                count = tick_counter;

                pattern_shift_next = pattern_shift; // hold pattern_shift
                delay_reg_next = delay_reg;
                delay_bit_count_next = 3'd0;

                if (cycle_counter == 10'd999) begin
                    cycle_counter_next = 10'd0;
                    if (tick_counter == 0) begin
                        // Counting finished, move to DONE
                        tick_counter_next = 4'd0;
                        next_state = DONE;
                    end else begin
                        tick_counter_next = tick_counter - 1'b1;
                        next_state = COUNTING;
                    end
                end else begin
                    cycle_counter_next = cycle_counter + 1'b1;
                    tick_counter_next = tick_counter;
                    next_state = COUNTING;
                end
            end

            DONE: begin
                counting_reg = 1'b0;
                done_reg = 1'b1;
                count = 4'd0;

                pattern_shift_next = pattern_shift; // hold pattern_shift (or reset on ack)
                delay_reg_next = 4'd0;
                delay_bit_count_next = 3'd0;
                cycle_counter_next = 10'd0;
                tick_counter_next = 4'd0;

                // Return to SEARCH on ack
                if (ack) begin
                    next_state = SEARCH;
                    pattern_shift_next = 4'd0; // reset pattern_shift to start fresh
                end else begin
                    next_state = DONE;
                end
            end

            default: begin
                next_state = SEARCH;
                pattern_shift_next = 4'd0;
                delay_reg_next = 4'd0;
                delay_bit_count_next = 3'd0;
                cycle_counter_next = 10'd0;
                tick_counter_next = 4'd0;
                counting_reg = 1'b0;
                done_reg = 1'b0;
                count = 4'd0;
            end
        endcase
    end

    // State and registers sequential update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            delay_bit_count <= 3'd0;
            cycle_counter <= 10'd0;
            tick_counter <= 4'd0;
            count <= 4'd0;
        end else begin
            state <= next_state;
            pattern_shift <= pattern_shift_next;
            delay_reg <= delay_reg_next;
            delay_bit_count <= delay_bit_count_next;
            cycle_counter <= cycle_counter_next;
            tick_counter <= tick_counter_next;
            count <= count;  // count driven combinationally per cycle by next_state logic
        end
    end

endmodule