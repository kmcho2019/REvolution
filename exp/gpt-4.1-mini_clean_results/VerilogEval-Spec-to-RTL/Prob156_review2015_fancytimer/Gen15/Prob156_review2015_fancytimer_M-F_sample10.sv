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
    // Shift left, insert new bit at LSB for MSB-first input
    reg [3:0] pattern_shift;

    // Delay register - shift left, insert new bit at LSB (MSB-first delay bits)
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded;  // counts 0 to 4

    // Cycle counter: counts 0..999 cycles per tick
    reg [9:0] cycle_counter;

    // Tick counter: counts remaining ticks down from delay+1 to 0
    reg [4:0] tick_counter;

    // Previous state for detecting transitions
    reg [1:0] prev_state;

    // Synchronous state and register updates
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
            prev_state <= SEARCH;
        end else begin
            prev_state <= state;
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift pattern_shift left by 1, insert new bit at LSB (MSB-first)
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay loading registers on entry or continuation of SEARCH
                    delay_reg <= 4'd0;
                    delay_bits_loaded <= 3'd0;

                    // Clear counters and outputs
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                DELAY_LOAD: begin
                    // Shift delay_reg left by 1 and insert new bit at LSB (MSB-first)
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;

                    // Maintain outputs and counters cleared during delay load
                    pattern_shift <= pattern_shift;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // During COUNT, pattern_shift and delay_reg stay unchanged
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;

                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;

                        if (tick_counter != 5'd0) begin
                            tick_counter <= tick_counter - 1'b1;
                        end else begin
                            tick_counter <= 5'd0;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end

                    // Update count output: shows tick_counter - 1 (number of ticks remaining minus one),
                    // clamped to zero when counting finished
                    if (tick_counter > 0)
                        count <= tick_counter - 1'b1;
                    else
                        count <= 4'd0;
                end

                WAIT_ACK: begin
                    // Wait for user ack
                    counting <= 1'b0;
                    done <= 1'b1;

                    // Clear registers and outputs
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    count <= 4'd0;
                end

                default: begin
                    // Default safe reset to SEARCH state
                    state <= SEARCH;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
            endcase

            // Initialize tick_counter and cycle_counter on transition DELAY_LOAD->COUNT
            if ((prev_state == DELAY_LOAD) && (state == COUNT)) begin
                // tick_counter = delay + 1
                tick_counter <= {1'b0, delay_reg} + 5'd1;
                cycle_counter <= 10'd0;

                // Initialize count to delay value (tick_counter - 1) for display
                count <= delay_reg;
            end
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state;

        case(state)
            SEARCH: begin
                // Detect pattern 1101 (binary) in pattern_shift after shifting
                // pattern_shift[3:0] holds last 4 bits received MSB-first
                if (pattern_shift == 4'b1101)
                    next_state = DELAY_LOAD;
                else
                    next_state = SEARCH;
            end

            DELAY_LOAD: begin
                // Once 4 delay bits loaded, move to COUNT
                if (delay_bits_loaded == 3'd4)
                    next_state = COUNT;
                else
                    next_state = DELAY_LOAD;
            end

            COUNT: begin
                // After counting all ticks, move to WAIT_ACK
                // tick_counter counts down to zero, cycle_counter counts 0-999 cycles
                if ((tick_counter == 5'd0) && (cycle_counter == 10'd999))
                    next_state = WAIT_ACK;
                else
                    next_state = COUNT;
            end

            WAIT_ACK: begin
                // Wait for ack before returning to SEARCH
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = WAIT_ACK;
            end

            default: next_state = SEARCH;
        endcase
    end

endmodule