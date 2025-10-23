module TopModule (
    input         clk,
    input         reset,   // synchronous active high
    input         data,
    output reg [3:0] count,
    output reg    counting,
    output reg    done,
    input         ack
);

    // FSM States
    typedef enum logic [1:0] {
        SEARCH     = 2'd0,
        DELAY_LOAD = 2'd1,
        COUNT      = 2'd2,
        WAIT_ACK   = 2'd3
    } state_t;

    state_t state, next_state;

    // Pattern detection shift register (4 bits)
    // Shift left, insert new data bit at LSB for MSB-first input stream
    reg [3:0] pattern_shift;

    // Delay register - load 4 bits MSB first by shifting left and inserting data at LSB
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded;  // counts from 0 up to 4

    // Cycle counter: counts 0..999 cycles per tick
    reg [9:0] cycle_counter;

    // Tick counter: counts remaining ticks down from delay+1 to 0
    reg [4:0] tick_counter;

    // Hold current stable count output for 1000 cycle intervals
    reg [3:0] current_count;

    // Previous state for detecting state transitions
    state_t prev_state;

    // Synchronous logic: state, counters, registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            delay_bits_loaded <= 3'd0;
            cycle_counter <= 10'd0;
            tick_counter <= 5'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
            current_count <= 4'd0;
            prev_state <= SEARCH;
        end else begin
            prev_state <= state;
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift pattern_shift left and insert new data bit at LSB (MSB-first)
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay loading variables on entry to SEARCH (also in reset)
                    if (prev_state != SEARCH)
                        delay_bits_loaded <= 3'd0;

                    // Clear outputs and counters
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    current_count <= 4'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    delay_reg <= delay_reg; // hold delay_reg until DELAY_LOAD
                end

                DELAY_LOAD: begin
                    // Shift in delay bits MSB-first: shift left, insert new data at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;

                    // Outputs and counters inactive during delay load
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    current_count <= 4'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    pattern_shift <= pattern_shift; // hold pattern_shift
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Maintain pattern and delay regs unchanged during counting
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;

                    // cycle_counter counts 0..999
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        // Decrement tick_counter if > 0
                        if (tick_counter != 0) begin
                            tick_counter <= tick_counter - 1'b1;
                            // Update current_count to reflect new tick
                            // current_count = tick_counter - 1 after decrement
                            if (tick_counter > 1)
                                current_count <= tick_counter[3:0] - 1'b1;
                            else
                                current_count <= 4'd0;
                        end else begin
                            // tick_counter == 0 means counting done; keep current_count=0
                            current_count <= 4'd0;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                        // current_count stable during 1000 cycles
                        current_count <= current_count;
                        tick_counter <= tick_counter;
                    end

                    count <= current_count;
                end

                WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;

                    // Clear outputs and registers waiting for ack
                    count <= 4'd0;
                    current_count <= 4'd0;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                end

                default: begin
                    // Should never happen; safe reset
                    state <= SEARCH;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    current_count <= 4'd0;
                end
            endcase

            // Initialize tick_counter, cycle_counter and current_count on DELAY_LOAD->COUNT transition
            if ((prev_state == DELAY_LOAD) && (state == COUNT)) begin
                // tick_counter = delay_reg + 1 (up to 16)
                tick_counter <= {1'b0, delay_reg} + 5'd1;
                cycle_counter <= 10'd0;
                current_count <= delay_reg;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;

        case(state)
            SEARCH: begin
                // When pattern_shift matches 1101, move to DELAY_LOAD
                if (pattern_shift == 4'b1101)
                    next_state = DELAY_LOAD;
                else
                    next_state = SEARCH;
            end

            DELAY_LOAD: begin
                // After 4 bits loaded, start COUNT
                if (delay_bits_loaded == 3'd4)
                    next_state = COUNT;
                else
                    next_state = DELAY_LOAD;
            end

            COUNT: begin
                // When counting finished (tick_counter == 0 and cycle_counter at end)
                if ((tick_counter == 0) && (cycle_counter == 10'd999))
                    next_state = WAIT_ACK;
                else
                    next_state = COUNT;
            end

            WAIT_ACK: begin
                // Wait for user ack to restart search
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = WAIT_ACK;
            end

            default: next_state = SEARCH;
        endcase
    end

endmodule