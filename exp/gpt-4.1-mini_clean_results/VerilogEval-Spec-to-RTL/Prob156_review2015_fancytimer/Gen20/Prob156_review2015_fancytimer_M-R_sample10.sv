module TopModule (
    input        clk,
    input        reset,  // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg      counting,
    output reg      done,
    input           ack
);

    // State encoding
    localparam IDLE       = 2'd0;
    localparam LOAD_DELAY = 2'd1;
    localparam COUNTING   = 2'd2;
    localparam DONE       = 2'd3;

    reg [1:0] state, state_next;

    // Pattern detection shift register
    reg [3:0] pattern_shift, pattern_shift_next;
    localparam [3:0] START_PATTERN = 4'b1101;

    // Delay loading registers
    reg [3:0] delay_reg, delay_reg_next;
    reg [2:0] delay_bits_loaded, delay_bits_loaded_next;

    // Counting registers
    reg [9:0] cycle_counter, cycle_counter_next; // counts 0..999 cycles
    reg [4:0] tick_counter, tick_counter_next;   // counts (delay+1) ticks down to 0 inclusive

    // Output registers next values
    reg [3:0] count_next;
    reg counting_next;
    reg done_next;

    // Combinational logic for next state and next values
    always @* begin
        // Defaults: hold values
        state_next = state;
        pattern_shift_next = pattern_shift;
        delay_reg_next = delay_reg;
        delay_bits_loaded_next = delay_bits_loaded;
        cycle_counter_next = cycle_counter;
        tick_counter_next = tick_counter;

        count_next = count; // default hold
        counting_next = counting;
        done_next = done;

        case (state)
            IDLE: begin
                // Shift pattern MSB first: shift left, input bit to LSB
                pattern_shift_next = {pattern_shift[2:0], data};

                // Outputs in IDLE: don't care count, counting=0, done=0
                count_next = 4'bxxxx;
                counting_next = 1'b0;
                done_next = 1'b0;

                // Reset delay loading info
                delay_bits_loaded_next = 3'd0;
                delay_reg_next = 4'd0;
                cycle_counter_next = 10'd0;
                tick_counter_next = 5'd0;

                // Check start pattern
                if (pattern_shift_next == START_PATTERN) begin
                    state_next = LOAD_DELAY;
                end
            end

            LOAD_DELAY: begin
                // Shift delay bits MSB first: shift left, input bit to LSB
                delay_reg_next = {delay_reg[2:0], data};
                delay_bits_loaded_next = delay_bits_loaded + 1'b1;

                // Hold pattern_shift; ignore pattern during load delay
                pattern_shift_next = pattern_shift;

                count_next = 4'bxxxx;
                counting_next = 1'b0;
                done_next = 1'b0;

                cycle_counter_next = 10'd0;
                tick_counter_next = tick_counter;

                if (delay_bits_loaded_next == 4) begin
                    // All delay bits loaded -> start counting next cycle
                    state_next = COUNTING;

                    cycle_counter_next = 10'd0;
                    // tick_counter counts from delay+1 down to 0
                    // Use delay_reg_next, which has the fully shifted-in delay bits
                    tick_counter_next = delay_reg_next + 1'b1;
                end
            end

            COUNTING: begin
                counting_next = 1'b1;
                done_next = 1'b0;

                // Output count = tick_counter - 1 or 0 when tick_counter==0
                if (tick_counter != 0)
                    count_next = tick_counter - 1'b1;
                else
                    count_next = 4'd0;

                // Hold pattern and delay registers unchanged
                pattern_shift_next = pattern_shift;
                delay_reg_next = delay_reg;
                delay_bits_loaded_next = delay_bits_loaded;

                // Counting cycles
                if (cycle_counter == 10'd999) begin
                    cycle_counter_next = 10'd0;
                    // Decrement tick_counter if not zero
                    if (tick_counter != 0) begin
                        tick_counter_next = tick_counter - 1'b1;
                    end else begin
                        tick_counter_next = 0;
                    end

                    // If last tick done (tick_counter was 1 before decrement), go to DONE
                    if (tick_counter == 1) begin
                        state_next = DONE;
                    end
                end else begin
                    cycle_counter_next = cycle_counter + 1'b1;
                    tick_counter_next = tick_counter;
                end
            end

            DONE: begin
                done_next = 1'b1;
                counting_next = 1'b0;
                count_next = 4'bxxxx;

                // Clear pattern and delay registers
                pattern_shift_next = 4'd0;
                delay_reg_next = 4'd0;
                delay_bits_loaded_next = 3'd0;
                cycle_counter_next = 10'd0;
                tick_counter_next = 5'd0;

                if (ack) begin
                    state_next = IDLE;
                end
            end

            default: begin
                // Should never happen, safe fallback
                state_next = IDLE;

                pattern_shift_next = 4'd0;
                delay_reg_next = 4'd0;
                delay_bits_loaded_next = 3'd0;
                cycle_counter_next = 10'd0;
                tick_counter_next = 5'd0;

                count_next = 4'bxxxx;
                counting_next = 1'b0;
                done_next = 1'b0;
            end
        endcase
    end

    // Sequential block: update registers and outputs synchronously
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;

            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            delay_bits_loaded <= 3'd0;
            cycle_counter <= 10'd0;
            tick_counter <= 5'd0;

            count <= 4'b0000;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= state_next;

            pattern_shift <= pattern_shift_next;
            delay_reg <= delay_reg_next;
            delay_bits_loaded <= delay_bits_loaded_next;
            cycle_counter <= cycle_counter_next;
            tick_counter <= tick_counter_next;

            count <= count_next;
            counting <= counting_next;
            done <= done_next;
        end
    end

endmodule