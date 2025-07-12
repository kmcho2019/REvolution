module TopModule (
    input         clk,
    input         reset,  // synchronous active high
    input         data,
    output reg [3:0] count,
    output reg      counting,
    output reg      done,
    input          ack
);

    // FSM states as localparam for synthesis friendliness
    localparam IDLE       = 2'd0;
    localparam LOAD_DELAY = 2'd1;
    localparam COUNTING   = 2'd2;
    localparam DONE       = 2'd3;

    reg [1:0] state, state_next;

    // Shift register for pattern detection (4 bits)
    reg [3:0] pattern_shift, pattern_shift_next;
    localparam [3:0] START_PATTERN = 4'b1101;

    // Delay loading
    reg [3:0] delay_reg, delay_reg_next;
    reg [2:0] delay_bits_loaded, delay_bits_loaded_next; // counts 0..4

    // Counting registers
    reg [9:0] cycle_counter, cycle_counter_next;  // counts 0..999
    reg [4:0] tick_counter, tick_counter_next;    // counts (delay+1) down to 0

    // Next output signals
    reg [3:0] count_next;
    reg       counting_next;
    reg       done_next;

    // Combinational logic to determine next state and next values
    always @(*) begin
        // Defaults to hold current values
        state_next = state;
        pattern_shift_next = pattern_shift;
        delay_reg_next = delay_reg;
        delay_bits_loaded_next = delay_bits_loaded;
        cycle_counter_next = cycle_counter;
        tick_counter_next = tick_counter;

        count_next = count;
        counting_next = counting;
        done_next = done;

        case (state)
            IDLE: begin
                counting_next = 1'b0;
                done_next = 1'b0;
                count_next = 4'bxxxx; // don't care

                // Shift in data bit MSB first for pattern detection
                pattern_shift_next = {pattern_shift[2:0], data};
                delay_bits_loaded_next = 3'd0;
                delay_reg_next = 4'd0;
                cycle_counter_next = 10'd0;
                tick_counter_next = 5'd0;

                if (pattern_shift_next == START_PATTERN) begin
                    state_next = LOAD_DELAY;
                end
            end

            LOAD_DELAY: begin
                counting_next = 1'b0;
                done_next = 1'b0;
                count_next = 4'bxxxx; // don't care

                // Shift in delay bits MSB first
                delay_reg_next = {delay_reg[2:0], data};
                delay_bits_loaded_next = delay_bits_loaded + 1'b1;

                // Hold pattern_shift, ignore input pattern now
                pattern_shift_next = pattern_shift;

                // Reset counters
                cycle_counter_next = 10'd0;
                tick_counter_next = tick_counter;

                if (delay_bits_loaded_next == 4) begin
                    // Delay is fully loaded, start counting next cycle
                    state_next = COUNTING;
                    // Initialize tick_counter with delay+1 for counting cycles
                    // The registered delay_reg_next value is stable on next clock
                    // so assign here delay_reg + 1 for tick_counter
                    // We'll assign tick_counter in sequential logic on state transition
                end
            end

            COUNTING: begin
                counting_next = 1'b1;
                done_next = 1'b0;

                pattern_shift_next = pattern_shift;  // ignore pattern now
                delay_reg_next = delay_reg;
                delay_bits_loaded_next = delay_bits_loaded;

                // count output is current tick_counter - 1, saturate at 0 if tick_counter==0
                if (tick_counter != 0)
                    count_next = tick_counter - 1;
                else
                    count_next = 4'd0;

                if (cycle_counter == 10'd999) begin
                    cycle_counter_next = 10'd0;

                    // Decrement tick_counter if not zero
                    if (tick_counter != 0) begin
                        tick_counter_next = tick_counter - 1'b1;
                    end

                    // If counting just finished (tick_counter was 1 before decrement)
                    if (tick_counter == 1) begin
                        state_next = DONE;
                    end
                end else begin
                    cycle_counter_next = cycle_counter + 1'b1;
                    tick_counter_next = tick_counter;
                end
            end

            DONE: begin
                counting_next = 1'b0;
                done_next = 1'b1;
                count_next = 4'bxxxx; // don't care

                // Reset pattern and delay for next time
                pattern_shift_next = 4'd0;
                delay_reg_next = 4'd0;
                delay_bits_loaded_next = 3'd0;
                cycle_counter_next = 10'd0;
                tick_counter_next = 5'd0;

                // Wait for ack to restart search for pattern
                if (ack) begin
                    state_next = IDLE;
                end
            end

            default: begin
                // Safely reset on unknown state
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

    // Sequential logic updates all registers and outputs on clock edge
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
            // Update state and internal registers
            state <= state_next;
            pattern_shift <= pattern_shift_next;
            delay_reg <= delay_reg_next;
            delay_bits_loaded <= delay_bits_loaded_next;
            cycle_counter <= cycle_counter_next;

            // Special case: Initialize tick_counter when entering COUNTING state
            if (state_next == COUNTING && state != COUNTING) begin
                // On transition into COUNTING, set tick_counter = delay_reg + 1
                tick_counter <= delay_reg + 1'b1;
            end else begin
                tick_counter <= tick_counter_next;
            end

            // Update outputs
            count <= count_next;
            counting <= counting_next;
            done <= done_next;
        end
    end

endmodule