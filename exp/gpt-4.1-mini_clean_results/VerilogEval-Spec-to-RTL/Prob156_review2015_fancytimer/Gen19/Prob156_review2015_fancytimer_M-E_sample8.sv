module TopModule (
    input        clk,
    input        reset,  // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg      counting,
    output reg      done,
    input           ack
);

    // FSM States
    typedef enum logic [1:0] {
        IDLE        = 2'd0,
        LOAD_DELAY  = 2'd1,
        COUNTING    = 2'd2,
        DONE        = 2'd3
    } state_t;

    state_t state, state_next;

    // Pattern detection shift register (4 bits)
    reg [3:0] pattern_shift, pattern_shift_next;
    localparam [3:0] START_PATTERN = 4'b1101;

    // Delay loading
    reg [3:0] delay_reg, delay_reg_next;    // 4 bits delay value
    reg [2:0] delay_bits_loaded, delay_bits_loaded_next; // counts bits 0..4

    // Counting
    reg [9:0] cycle_counter, cycle_counter_next; // counts 0..999 cycles
    reg [4:0] tick_counter, tick_counter_next;   // counts (delay+1) ticks, 5 bits to cover max 16

    // Combinational next state and outputs
    always @(*) begin
        // Defaults
        state_next = state;
        pattern_shift_next = pattern_shift;
        delay_reg_next = delay_reg;
        delay_bits_loaded_next = delay_bits_loaded;
        cycle_counter_next = cycle_counter;
        tick_counter_next = tick_counter;

        count = 4'bxxxx;       // Default don't care when not counting
        counting = 1'b0;
        done = 1'b0;

        case (state)
            IDLE: begin
                // Shift in pattern MSB first: shift left, insert new data bit at LSB
                pattern_shift_next = {pattern_shift[2:0], data};

                count = 4'bxxxx;
                counting = 1'b0;
                done = 1'b0;

                delay_bits_loaded_next = 3'd0;
                delay_reg_next = 4'd0;
                cycle_counter_next = 10'd0;
                tick_counter_next = 5'd0;

                // Detect start pattern
                if (pattern_shift_next == START_PATTERN) begin
                    state_next = LOAD_DELAY;
                end
            end

            LOAD_DELAY: begin
                // Shift in delay bits MSB first: shift left, insert new data bit at LSB
                delay_reg_next = {delay_reg[2:0], data};
                delay_bits_loaded_next = delay_bits_loaded + 1'b1;

                // Hold pattern_shift (ignore input pattern now)
                pattern_shift_next = pattern_shift;

                count = 4'bxxxx;
                counting = 1'b0;
                done = 1'b0;

                cycle_counter_next = 10'd0;
                tick_counter_next = tick_counter;

                if (delay_bits_loaded_next == 4) begin
                    // All 4 delay bits loaded, start counting
                    state_next = COUNTING;
                    cycle_counter_next = 10'd0;
                    // tick_counter counts from delay+1 down to 0 inclusive (e.g. delay=0 -> tick_counter=1)
                    tick_counter_next = delay_reg_next + 1'b1;
                end
            end

            COUNTING: begin
                counting = 1'b1;
                done = 1'b0;

                // Output count is current tick_counter - 1, saturating at 0
                // Because tick_counter counts down from delay+1 to 0:
                // For example, if tick_counter=3, count=2; if tick_counter=1, count=0
                if (tick_counter != 0) begin
                    count = tick_counter - 1;
                end else begin
                    count = 4'd0;
                end

                pattern_shift_next = pattern_shift; // no pattern detection now
                delay_reg_next = delay_reg;
                delay_bits_loaded_next = delay_bits_loaded;

                if (cycle_counter == 10'd999) begin
                    cycle_counter_next = 10'd0;
                    if (tick_counter != 0) begin
                        tick_counter_next = tick_counter - 1'b1;
                    end

                    // If tick_counter just became zero (finished counting all ticks), move to DONE next cycle
                    if (tick_counter == 1) begin
                        state_next = DONE;
                    end
                end else begin
                    cycle_counter_next = cycle_counter + 1'b1;
                    tick_counter_next = tick_counter;
                end
            end

            DONE: begin
                done = 1'b1;
                counting = 1'b0;
                count = 4'bxxxx; // don't care

                pattern_shift_next = 4'd0;
                delay_reg_next = 4'd0;
                delay_bits_loaded_next = 3'd0;
                cycle_counter_next = 10'd0;
                tick_counter_next = 5'd0;

                if (ack) begin
                    // After ack, go back to searching pattern
                    state_next = IDLE;
                end
            end

            default: begin
                // Safety fallback
                state_next = IDLE;
                pattern_shift_next = 4'd0;
                delay_reg_next = 4'd0;
                delay_bits_loaded_next = 3'd0;
                cycle_counter_next = 10'd0;
                tick_counter_next = 5'd0;
                count = 4'bxxxx;
                counting = 1'b0;
                done = 1'b0;
            end
        endcase
    end

    // Sequential state and register updates
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            delay_bits_loaded <= 3'd0;
            cycle_counter <= 10'd0;
            tick_counter <= 5'd0;

            count <= 4'bxxxx;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= state_next;
            pattern_shift <= pattern_shift_next;
            delay_reg <= delay_reg_next;
            delay_bits_loaded <= delay_bits_loaded_next;
            cycle_counter <= cycle_counter_next;
            tick_counter <= tick_counter_next;

            count <= count;
            counting <= counting;
            done <= done;
        end
    end

endmodule