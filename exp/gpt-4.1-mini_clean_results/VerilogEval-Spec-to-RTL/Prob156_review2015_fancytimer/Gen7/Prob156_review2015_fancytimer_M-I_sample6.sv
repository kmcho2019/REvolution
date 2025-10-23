module TopModule(
    input        clk,
    input        reset, // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // State encoding
    typedef enum reg [1:0] {
        SEARCH      = 2'b00,
        LOAD_DELAY  = 2'b01,
        COUNTING    = 2'b10,
        DONE_WAIT   = 2'b11
    } state_t;

    state_t state, next_state;

    // Shift register for pattern detection (4 bits)
    reg [3:0] pattern_shift;

    // Delay loading registers
    reg [2:0] load_bits_cnt;     // counts bits loaded in LOAD_DELAY (0..4)
    reg [3:0] delay_reg;

    // Counting registers
    reg [13:0] cycle_counter;    // counts total cycles from 0 to total_count-1
    reg [13:0] total_count;      // (delay + 1)*1000
    reg [9:0]  block_counter;    // counts 0..999 within each 1000-cycle block
    reg [3:0]  remaining_ticks;  // counts down from delay to 0

    // Synchronous FSM and registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;

            pattern_shift <= 4'b0000;

            load_bits_cnt <= 3'd0;
            delay_reg <= 4'd0;

            cycle_counter <= 14'd0;
            total_count <= 14'd0;

            block_counter <= 10'd0;
            remaining_ticks <= 4'd0;

            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift in new data bit at LSB for pattern detection (MSB-first incoming bits)
                    // pattern_shift holds last 4 bits: pattern_shift = {pattern_shift[2:0], data}
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Reset all counters and outputs
                    load_bits_cnt <= 3'd0;
                    delay_reg <= 4'd0;

                    cycle_counter <= 14'd0;
                    total_count <= 14'd0;

                    block_counter <= 10'd0;
                    remaining_ticks <= 4'd0;

                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB-first:
                    // The first bit received becomes delay_reg[3], so shift delay_reg right and insert data at MSB
                    // delay_reg = {data, delay_reg[3:1]}
                    delay_reg <= {data, delay_reg[3:1]};

                    load_bits_cnt <= load_bits_cnt + 1'b1;

                    // pattern_shift holds (no update)
                    pattern_shift <= pattern_shift;

                    // Reset counters and outputs
                    cycle_counter <= 14'd0;
                    total_count <= 14'd0;
                    block_counter <= 10'd0;
                    remaining_ticks <= 4'd0;

                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                COUNTING: begin
                    pattern_shift <= pattern_shift;
                    load_bits_cnt <= load_bits_cnt;
                    delay_reg <= delay_reg;

                    counting <= 1'b1;
                    done <= 1'b0;

                    // cycle_counter counts total cycles elapsed in counting
                    if (cycle_counter == total_count - 1)
                        cycle_counter <= 14'd0;
                    else
                        cycle_counter <= cycle_counter + 1'b1;

                    // block_counter counts cycles within each 1000 cycle block (0 to 999)
                    if (block_counter == 10'd999)
                        block_counter <= 10'd0;
                    else
                        block_counter <= block_counter + 1'b1;

                    // Decrement remaining_ticks only at end of each 1000-cycle block (when block_counter hits 999)
                    if (block_counter == 10'd999) begin
                        if (remaining_ticks != 0)
                            remaining_ticks <= remaining_ticks - 1'b1;
                        else
                            remaining_ticks <= remaining_ticks; // stay at 0
                    end else begin
                        remaining_ticks <= remaining_ticks;
                    end

                    // count output is stable during each 1000-cycle block, equals remaining_ticks
                    count <= remaining_ticks;
                end

                DONE_WAIT: begin
                    // Hold done asserted, others inactive
                    pattern_shift <= pattern_shift;
                    load_bits_cnt <= load_bits_cnt;
                    delay_reg <= delay_reg;
                    cycle_counter <= 14'd0;
                    total_count <= 14'd0;
                    block_counter <= 10'd0;
                    remaining_ticks <= 4'd0;

                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b1;
                end

                default: begin
                    // Default reset to SEARCH
                    state <= SEARCH;
                    pattern_shift <= 4'b0000;

                    load_bits_cnt <= 3'd0;
                    delay_reg <= 4'd0;

                    cycle_counter <= 14'd0;
                    total_count <= 14'd0;

                    block_counter <= 10'd0;
                    remaining_ticks <= 4'd0;

                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;

        case(state)
            SEARCH: begin
                // When pattern detected, move to LOAD_DELAY
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                // After loading 4 delay bits, go to COUNTING
                if (load_bits_cnt == 3'd4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // After total_count cycles, go to DONE_WAIT
                if (cycle_counter == total_count - 1)
                    next_state = DONE_WAIT;
            end

            DONE_WAIT: begin
                // Wait for ack to return to SEARCH
                if (ack)
                    next_state = SEARCH;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Load total_count and initialize remaining_ticks and counters at transition LOAD_DELAY -> COUNTING
    reg load_delay_prev;
    always @(posedge clk) begin
        if (reset) begin
            load_delay_prev <= 1'b0;
        end else begin
            load_delay_prev <= (state == LOAD_DELAY);
        end
    end

    always @(posedge clk) begin
        if (!reset) begin
            // Detect rising edge from LOAD_DELAY to COUNTING
            if (load_delay_prev && (next_state == COUNTING)) begin
                // total_count = (delay_reg + 1) * 1000 cycles
                total_count <= ( {10'd0, delay_reg} + 14'd1 ) * 14'd1000;
                // Initialize remaining_ticks = delay_reg (will count down to 0)
                remaining_ticks <= delay_reg;
                // Reset counters
                cycle_counter <= 14'd0;
                block_counter <= 10'd0;
            end
        end
    end

endmodule