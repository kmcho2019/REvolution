module TopModule (
    input        clk,
    input        reset,   // synchronous active high
    input        data,
    output [3:0] count,
    output       counting,
    output       done,
    input        ack
);

    // FSM states
    typedef enum logic [1:0] {
        SEARCH     = 2'd0,
        DELAY_LOAD = 2'd1,
        COUNT      = 2'd2,
        WAIT_ACK   = 2'd3
    } state_t;

    state_t state, next_state;

    // Shift registers for pattern detection and delay loading (MSB-first input)
    reg [3:0] pattern_shift;    // to detect pattern 1101
    reg [3:0] delay_shift;      // load 4 delay bits MSB-first
    reg [2:0] delay_bits_cnt;   // counts number of delay bits loaded (0..4)

    // Latch delay value on DELAY_LOAD done
    reg [3:0] delay_value;

    // Counters for timing
    reg [9:0] cycle_counter;    // counts 0..999 (1000 cycles per tick)
    reg [4:0] tick_counter;     // counts delay+1 down to 0

    // Inputs are sampled at each clock rising edge, synchronous FSM and registers
    always @(posedge clk) begin
        if (reset) begin
            // Reset all state and registers
            state <= SEARCH;
            pattern_shift <= 4'd0;
            delay_shift <= 4'd0;
            delay_bits_cnt <= 3'd0;
            delay_value <= 4'd0;
            cycle_counter <= 10'd0;
            tick_counter <= 5'd0;
        end else begin
            state <= next_state;
            case(state)
                SEARCH: begin
                    // Shift in data at LSB (MSB-first input) into pattern_shift
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_shift <= delay_shift;
                    delay_bits_cnt <= 3'd0;
                    delay_value <= delay_value;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                end

                DELAY_LOAD: begin
                    // Shift in delay bits MSB-first: shift left, input at LSB
                    delay_shift <= {delay_shift[2:0], data};
                    delay_bits_cnt <= delay_bits_cnt + 1'b1;
                    pattern_shift <= pattern_shift;
                    delay_value <= delay_value;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                end

                COUNT: begin
                    // Freeze pattern and delay registers
                    pattern_shift <= pattern_shift;
                    delay_shift <= delay_shift;
                    delay_bits_cnt <= delay_bits_cnt;
                    delay_value <= delay_value;

                    // Increment cycle_counter each clock
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (tick_counter != 0)
                            tick_counter <= tick_counter - 1'b1;
                        else
                            tick_counter <= tick_counter; // hold at 0
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end
                end

                WAIT_ACK: begin
                    // Reset registers to prepare for new sequence after ack
                    pattern_shift <= 4'd0;
                    delay_shift <= 4'd0;
                    delay_bits_cnt <= 3'd0;
                    delay_value <= delay_value;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                end

                default: begin
                    // Defensive default reset
                    pattern_shift <= 4'd0;
                    delay_shift <= 4'd0;
                    delay_bits_cnt <= 3'd0;
                    delay_value <= 4'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                end
            endcase

            // Latch delay_value when delay bits fully loaded
            if (state == DELAY_LOAD && delay_bits_cnt == 3'd3) begin
                // Next cycle delay_bits_cnt will be 4 after this increment, so latch now
                // delay_shift after current shift holds all 4 bits MSB-first
                delay_value <= {delay_shift[2:0], data};
            end

            // Initialize tick_counter on transition DELAY_LOAD -> COUNT
            if (state == DELAY_LOAD && next_state == COUNT) begin
                tick_counter <= {1'b0, delay_value} + 5'd1; // delay+1
                cycle_counter <= 10'd0;
            end

            // Clear delay_value after WAIT_ACK to avoid stale data (optional)
            if (state == WAIT_ACK && next_state == SEARCH) begin
                delay_value <= 4'd0;
            end
        end
    end

    // Next state logic (pure combinational)
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                // Detect pattern 1101 MSB-first in pattern_shift
                // Since pattern_shift is shifted left with new bits at LSB,
                // the bits correspond MSB first: pattern_shift[3] first bit, ... pattern_shift[0] last bit
                // So compare pattern_shift == 4'b1101
                if (pattern_shift == 4'b1101)
                    next_state = DELAY_LOAD;
                else
                    next_state = SEARCH;
            end

            DELAY_LOAD: begin
                if (delay_bits_cnt == 3'd4)
                    next_state = COUNT;
                else
                    next_state = DELAY_LOAD;
            end

            COUNT: begin
                // Done when tick_counter == 0 and cycle_counter == 999 (end of last 1000 cycles)
                if ((tick_counter == 0) && (cycle_counter == 10'd999))
                    next_state = WAIT_ACK;
                else
                    next_state = COUNT;
            end

            WAIT_ACK: begin
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = WAIT_ACK;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Output logic (pure combinational)
    // counting is high during COUNT state
    assign counting = (state == COUNT);

    // done asserted during WAIT_ACK state
    assign done = (state == WAIT_ACK);

    // Output count: shows remaining tick count stable for 1000 cycles
    // During COUNT, count = tick_counter - 1 if tick_counter > 0, else 0
    // During other states, count is 'x (don't care), but assign 0 for safety
    assign count = (state == COUNT) ? ((tick_counter != 0) ? (tick_counter - 1'b1) : 4'd0) : 4'd0;

endmodule