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
        START_DETECT = 2'd0,
        DELAY_LOAD   = 2'd1,
        COUNT        = 2'd2,
        WAIT_ACK     = 2'd3
    } state_t;

    state_t state, next_state;

    // Shift register for pattern detection (4 bits)
    reg [3:0] pattern_shift;

    // Delay register for 4 delay bits MSB first
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded; // count 0..4

    // Counting logic
    reg [9:0] cycle_counter;   // counts 0..999 clock cycles per tick
    reg [4:0] tick_counter;    // counts ticks down from delay+1 to 0
    reg [3:0] current_tick;    // stable count value for current 1000 cycles

    // FSM state register
    always @(posedge clk) begin
        if (reset) begin
            state <= START_DETECT;
        end else begin
            state <= next_state;
        end
    end

    // FSM next state logic
    always @(*) begin
        next_state = state;
        case(state)
            START_DETECT: begin
                // After shifting pattern_shift, check if matches 1101
                if (pattern_shift == 4'b1101)
                    next_state = DELAY_LOAD;
            end

            DELAY_LOAD: begin
                // After loading 4 bits delay, go to COUNT
                if (delay_bits_loaded == 3'd4)
                    next_state = COUNT;
            end

            COUNT: begin
                // After finishing all ticks and cycles, go to WAIT_ACK
                // Counting done when tick_counter == 0 and cycle_counter == 999 (end of last cycle)
                if ((tick_counter == 5'd0) && (cycle_counter == 10'd999))
                    next_state = WAIT_ACK;
            end

            WAIT_ACK: begin
                if (ack)
                    next_state = START_DETECT;
            end

            default: next_state = START_DETECT;
        endcase
    end

    // Sequential logic for pattern shift, delay load, counters, and outputs
    always @(posedge clk) begin
        if (reset) begin
            // Reset all
            pattern_shift     <= 4'd0;
            delay_reg         <= 4'd0;
            delay_bits_loaded <= 3'd0;

            cycle_counter <= 10'd0;
            tick_counter  <= 5'd0;
            current_tick  <= 4'd0;

            counting <= 1'b0;
            done     <= 1'b0;
            count    <= 4'd0;
        end else begin
            case(state)
                START_DETECT: begin
                    // Shift in data MSB first - new bit enters at LSB
                    // pattern_shift shifts left, insert data at LSB
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay loading variables
                    delay_reg         <= 4'd0;
                    delay_bits_loaded <= 3'd0;

                    // Clear counters and outputs
                    cycle_counter <= 10'd0;
                    tick_counter  <= 5'd0;
                    current_tick  <= 4'd0;

                    counting <= 1'b0;
                    done     <= 1'b0;
                    count    <= 4'd0;
                end

                DELAY_LOAD: begin
                    // Shift in delay bits MSB first, i.e. first bit loaded becomes delay[3]
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;

                    // Outputs stable low while loading
                    counting <= 1'b0;
                    done     <= 1'b0;
                    count    <= 4'd0;

                    // Pattern_shift not needed here; keep last value or clear
                    pattern_shift <= pattern_shift; // no change
                end

                COUNT: begin
                    counting <= 1'b1;
                    done     <= 1'b0;

                    // On first cycle of COUNT state (detecting transition),
                    // initialize tick_counter and current_tick once
                    // To detect state entry, use previous state stored separately

                    // cycle_counter increments 0..999 per tick
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;

                        // Decrement tick_counter if not zero
                        if (tick_counter != 5'd0) begin
                            tick_counter <= tick_counter - 1'b1;
                            // Update current_tick accordingly
                            // current_tick = tick_counter - 1 (since tick_counter decremented now)
                            current_tick <= (tick_counter - 1'b1)[3:0];
                        end else begin
                            // tick_counter == 0 means last tick done
                            tick_counter <= 5'd0;
                            current_tick <= 4'd0;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                        // current_tick stays the same during 1000 cycles
                    end

                    // count outputs current_tick stable for 1000 cycles
                    count <= current_tick;

                    // pattern_shift and delay_regs no longer used in this state
                end

                WAIT_ACK: begin
                    counting <= 1'b0;
                    done     <= 1'b1;
                    count    <= 4'd0;

                    // Clear other signals
                    pattern_shift     <= 4'd0;
                    delay_reg         <= 4'd0;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter     <= 10'd0;
                    tick_counter      <= 5'd0;
                    current_tick      <= 4'd0;
                end

                default: begin
                    // Default safe values
                    counting <= 1'b0;
                    done     <= 1'b0;
                    count    <= 4'd0;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    current_tick <= 4'd0;
                end
            endcase
        end
    end

    // To initialize tick_counter and current_tick on entering COUNT state,
    // use a registered previous state
    reg [1:0] prev_state;
    always @(posedge clk) begin
        if (reset) begin
            prev_state <= START_DETECT;
        end else begin
            prev_state <= state;

            if ((prev_state != COUNT) && (state == COUNT)) begin
                // Initialize tick_counter = delay + 1 (max 17)
                tick_counter <= {1'b0, delay_reg} + 5'd1;
                // current_tick initially delay_reg (displayed first)
                current_tick <= delay_reg;
                // Reset cycle_counter at start of COUNT
                cycle_counter <= 10'd0;
            end
        end
    end

endmodule