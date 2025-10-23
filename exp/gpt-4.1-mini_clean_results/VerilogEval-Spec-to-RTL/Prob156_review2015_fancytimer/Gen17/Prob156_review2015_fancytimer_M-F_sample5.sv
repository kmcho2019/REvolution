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
    // Shift new bits in MSB to LSB order:
    // At each clock, pattern_shift <= {pattern_shift[2:0], data} shifted incorrectly because LSB appended.
    // Instead, shift left and insert new bit at LSB is okay for MSB-first only if pattern_shift[3] oldest, [0] newest.
    // But pattern_shift must reflect most recent 4 bits, with newest bit at MSB to match MSB-first input.
    // Better to shift right and put new bit at MSB:
    // pattern_shift <= {data, pattern_shift[3:1]};
    // This way, pattern_shift[3] is newest bit received, pattern_shift[0] is oldest.
    // For input "1101" MSB-first: first bit '1' shifted into MSB, then '1' next into MSB, etc.
    // After receiving 4 bits, pattern_shift matches 4'b1101 if compared as is.

    reg [3:0] pattern_shift;
    reg [3:0] delay_shift;
    reg [2:0] delay_bits_cnt;   // counts delay bits received (0..4)

    reg [3:0] delay_value;

    reg [9:0] cycle_counter;    // counts 0..999 cycles
    reg [4:0] tick_counter;     // counts down from delay+1 to 1

    // State register and synchronous reset
    always @(posedge clk) begin
        if (reset) begin
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
                    // Shift new data bit into MSB for MSB-first pattern detection
                    pattern_shift <= {pattern_shift[2:0], data}; // old code caused reversed pattern detection
                    // Fix: shift right, new data into MSB
                    // so pattern_shift <= {data, pattern_shift[3:1]};
                    // But to align with next_state logic, we must fix pattern detection below too.
                    pattern_shift <= {data, pattern_shift[3:1]};
                    // During SEARCH, reset delay-related regs
                    delay_shift <= 4'd0;
                    delay_bits_cnt <= 3'd0;
                    // counters off during search
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                end

                DELAY_LOAD: begin
                    // Shift delay bits MSB-first same as pattern: new bit into MSB
                    delay_shift <= {data, delay_shift[3:1]};
                    delay_bits_cnt <= delay_bits_cnt + 1'b1;
                    // pattern_shift held
                    pattern_shift <= pattern_shift;
                    // counters reset
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;

                    // Latch delay_value immediately when 4 bits loaded
                    if (delay_bits_cnt == 3'd3) begin
                        delay_value <= {data, delay_shift[3:1]};
                    end
                end

                COUNT: begin
                    // Hold pattern and delay registers stable
                    pattern_shift <= pattern_shift;
                    delay_shift <= delay_shift;
                    delay_bits_cnt <= delay_bits_cnt;
                    delay_value <= delay_value;

                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (tick_counter > 1)
                            tick_counter <= tick_counter - 1'b1;
                        else
                            tick_counter <= 5'd1; // keep at 1 until done to complete final 1000 cycles
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                        tick_counter <= tick_counter;
                    end
                end

                WAIT_ACK: begin
                    // Clear pattern and delay for next search after ack
                    pattern_shift <= 4'd0;
                    delay_shift <= 4'd0;
                    delay_bits_cnt <= 3'd0;
                    delay_value <= 4'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                end

                default: begin
                    pattern_shift <= 4'd0;
                    delay_shift <= 4'd0;
                    delay_bits_cnt <= 3'd0;
                    delay_value <= 4'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                end
            endcase

            // Initialize counters on entering COUNT state:
            // Detect rising edge of COUNT state to initialize counters.
            if (state != COUNT && next_state == COUNT) begin
                cycle_counter <= 10'd0;
                tick_counter <= delay_value + 5'd1; // start with delay+1
            end
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                // Compare pattern_shift to 4'b1101
                // pattern_shift now shifted in MSB first with new bit at MSB,
                // so after 4 bits: pattern_shift[3:0] matches bits in correct order.
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
                // done when last 1000 cycles completed:
                // cycle_counter == 999 and tick_counter == 1 (lowest tick count, final tick)
                if ((cycle_counter == 10'd999) && (tick_counter == 5'd1))
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

    // Outputs
    assign counting = (state == COUNT);
    assign done = (state == WAIT_ACK);

    // Output count:
    // Shows remaining time count stable for 1000 cycles per decrement:
    // count = tick_counter - 1 during counting (because counting from delay to 0)
    // count = 0 otherwise (don't care)
    assign count = (state == COUNT) ? (tick_counter - 1'b1) : 4'd0;

endmodule