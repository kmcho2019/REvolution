module TopModule(
    input        clk,
    input        reset,  // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // FSM states
    localparam SEARCH      = 3'd0;
    localparam LOAD_DELAY  = 3'd1;
    localparam COUNTING    = 3'd2;
    localparam DONE_WAIT   = 3'd3;

    reg [2:0] state, next_state;

    // Pattern detection shift register (4 bits)
    reg [3:0] pattern_shift;

    // Delay loading
    reg [3:0] delay_shift;  // shift in 4 bits serially, MSB first
    reg [2:0] delay_bits_cnt; // counts bits shifted in (0 to 3)

    reg [3:0] delay_reg;    // final delay value loaded, MSB-first

    // Counting
    // Count down from (delay+1)*1000 to 0
    reg [13:0] countdown;   // max 16000 (for delay=15)
    reg [9:0] cycle_block;  // counts 0..999 for decrementing remaining_ticks

    reg [3:0] remaining_ticks; // counts down from delay to zero every 1000 cycles

    // === Synchronous state and registers update ===
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;

            pattern_shift <= 4'b0;

            delay_shift <= 4'b0;
            delay_bits_cnt <= 3'd0;
            delay_reg <= 4'b0;

            countdown <= 14'd0;
            cycle_block <= 10'd0;
            remaining_ticks <= 4'd0;

            count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift in data MSB first: pattern_shift <= {pattern_shift[2:0], data}
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay shift loading registers
                    delay_shift <= 4'b0;
                    delay_bits_cnt <= 3'd0;

                    delay_reg <= delay_reg; // hold old value until loaded

                    countdown <= 14'd0;
                    cycle_block <= 10'd0;
                    remaining_ticks <= 4'd0;

                    count <= 4'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                LOAD_DELAY: begin
                    // Shift in 4 bits MSB first:
                    // Since bits arrive MSB first, each new bit is appended at LSB of delay_shift.
                    // To have first bit at delay_shift[3], shift delay_shift left and insert data at LSB:
                    delay_shift <= {delay_shift[2:0], data};

                    delay_bits_cnt <= delay_bits_cnt + 1'b1;

                    pattern_shift <= pattern_shift; // hold pattern

                    // Hold outputs inactive
                    count <= 4'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                COUNTING: begin
                    pattern_shift <= pattern_shift;
                    delay_shift <= delay_shift;
                    delay_bits_cnt <= delay_bits_cnt;

                    counting <= 1'b1;
                    done <= 1'b0;

                    // countdown counts down every cycle if > 0
                    if (countdown != 0)
                        countdown <= countdown - 1'b1;
                    else
                        countdown <= 14'd0;

                    // cycle_block increments each clock cycle to count 1000 cycle block
                    if (cycle_block == 10'd999)
                        cycle_block <= 10'd0;
                    else
                        cycle_block <= cycle_block + 1'b1;

                    // decrement remaining_ticks every 1000 cycles (when cycle_block hits 999)
                    if (cycle_block == 10'd999 && remaining_ticks != 0)
                        remaining_ticks <= remaining_ticks - 1'b1;
                    else
                        remaining_ticks <= remaining_ticks;

                    // count output shows remaining_ticks
                    count <= remaining_ticks;
                end

                DONE_WAIT: begin
                    // Hold outputs indicating done state
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0;

                    // Hold registers stable
                    pattern_shift <= pattern_shift;
                    delay_shift <= delay_shift;
                    delay_bits_cnt <= delay_bits_cnt;
                    delay_reg <= delay_reg;

                    countdown <= 14'd0;
                    cycle_block <= 10'd0;
                    remaining_ticks <= 4'd0;
                end

                default: begin
                    // Should not happen: reset all
                    state <= SEARCH;
                    pattern_shift <= 4'b0;
                    delay_shift <= 4'b0;
                    delay_bits_cnt <= 3'd0;
                    delay_reg <= 4'b0;
                    countdown <= 14'd0;
                    cycle_block <= 10'd0;
                    remaining_ticks <= 4'd0;
                    count <= 4'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

    // === Next state logic ===
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                if (delay_bits_cnt == 3'd4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                if (countdown == 0)
                    next_state = DONE_WAIT;
            end

            DONE_WAIT: begin
                if (ack)
                    next_state = SEARCH;
            end

            default: next_state = SEARCH;
        endcase
    end

    // === Delay register update after all bits loaded ===
    // Because bits are shifted in MSB first into delay_shift by shifting left and inserting LSB,
    // delay_shift has bits in order: first bit at bit3, last bit at bit0.
    // So delay_reg = delay_shift as is.

    always @(posedge clk) begin
        if (reset) begin
            delay_reg <= 4'b0;
        end else begin
            if (state == LOAD_DELAY && delay_bits_cnt == 3'd3) begin
                // After last bit shifted in (this is the 4th bit: counts 0..3), update delay_reg
                delay_reg <= {delay_shift[2:0], data}; // complete 4 bits now loaded
            end
        end
    end

    // === countdown and remaining_ticks initialization at COUNTING start ===
    reg prev_state_load_delay;
    always @(posedge clk) begin
        if (reset) begin
            prev_state_load_delay <= 1'b0;
        end else begin
            prev_state_load_delay <= (state == LOAD_DELAY);
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            countdown <= 14'd0;
            remaining_ticks <= 4'd0;
            cycle_block <= 10'd0;
        end else begin
            // Detect rising edge LOAD_DELAY->COUNTING to initialize countdown and remaining_ticks
            if (prev_state_load_delay && (state == COUNTING)) begin
                // countdown = (delay_reg + 1)*1000
                // Use multiplication as 1000 = 10'b1111101000
                countdown <= ( {10'd0, delay_reg} + 14'd1 ) * 14'd1000;
                remaining_ticks <= delay_reg;
                cycle_block <= 10'd0;
            end
        end
    end

endmodule