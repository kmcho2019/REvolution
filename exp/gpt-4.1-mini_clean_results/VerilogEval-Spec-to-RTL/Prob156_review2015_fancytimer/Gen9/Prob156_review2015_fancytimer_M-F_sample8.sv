module TopModule(
    input        clk,
    input        reset, // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // FSM states
    localparam SEARCH      = 2'd0;
    localparam LOAD_DELAY  = 2'd1;
    localparam COUNTING    = 2'd2;
    localparam DONE_WAIT   = 2'd3;

    reg [1:0] state, next_state;

    // For pattern detection (shift in each bit, MSB oldest)
    reg [3:0] pattern_shift;

    // For loading delay bits (4 bits)
    reg [2:0] load_bits_cnt;      // counts 0..4 to handle 4 bits loading
    reg [3:0] delay_reg;

    // Counting counters
    reg [9:0] cycle_subcount;     // counts 0..999 within a 1000 cycle block
    reg [4:0] remaining_ticks;    // one extra bit to hold delay+1 safely

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            load_bits_cnt <= 3'd0;
            delay_reg <= 4'd0;
            cycle_subcount <= 10'd0;
            remaining_ticks <= 5'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift in data bit to pattern_shift (MSB oldest)
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay loading and counters
                    load_bits_cnt <= 3'd0;
                    delay_reg <= 4'd0;
                    cycle_subcount <= 10'd0;
                    remaining_ticks <= 5'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                LOAD_DELAY: begin
                    // Shift delay_reg left by 1, insert new bit at LSB
                    delay_reg <= {delay_reg[2:0], data};

                    load_bits_cnt <= load_bits_cnt + 1'b1;

                    // Keep pattern_shift unchanged during load_delay
                    pattern_shift <= pattern_shift;

                    counting <= 1'b0;
                    done <= 1'b0;
                    cycle_subcount <= 10'd0;
                    remaining_ticks <= 5'd0;
                    count <= 4'd0;
                end

                COUNTING: begin
                    // Hold pattern_shift and load_bits_cnt steady
                    pattern_shift <= pattern_shift;
                    load_bits_cnt <= load_bits_cnt;
                    delay_reg <= delay_reg;

                    counting <= 1'b1;
                    done <= 1'b0;

                    // Increment cycle_subcount each clock cycle
                    if (cycle_subcount == 10'd999) begin
                        cycle_subcount <= 10'd0;
                        // Decrement remaining_ticks if > 0
                        if (remaining_ticks != 5'd0)
                            remaining_ticks <= remaining_ticks - 1'b1;
                        else
                            remaining_ticks <= remaining_ticks; // hold at zero
                    end else begin
                        cycle_subcount <= cycle_subcount + 1'b1;
                        remaining_ticks <= remaining_ticks; // hold steady
                    end

                    // Output current remaining_ticks as 4-bit count during counting
                    count <= remaining_ticks[3:0];
                end

                DONE_WAIT: begin
                    // Hold outputs to indicate done
                    pattern_shift <= pattern_shift;
                    load_bits_cnt <= load_bits_cnt;
                    delay_reg <= delay_reg;
                    cycle_subcount <= 10'd0;
                    remaining_ticks <= 5'd0;

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;
                end

                default: begin
                    state <= SEARCH;
                    pattern_shift <= 4'b0000;
                    load_bits_cnt <= 3'd0;
                    delay_reg <= 4'd0;
                    cycle_subcount <= 10'd0;
                    remaining_ticks <= 5'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase

            // Load remaining_ticks with delay+1 at the cycle when entering COUNTING
            // Detect transition from LOAD_DELAY to COUNTING
            if ((state == LOAD_DELAY) && (next_state == COUNTING)) begin
                remaining_ticks <= {1'b0, delay_reg} + 5'd1;
                cycle_subcount <= 10'd0; // reset cycle counter at start counting
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                // Wait for pattern 1101
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                // Wait until 4 bits are loaded (load_bits_cnt counts 0..4)
                if (load_bits_cnt == 3'd4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // Counting finishes when remaining_ticks==0 AND cycle_subcount==999 (end of last 1000-cycle block)
                if ((remaining_ticks == 5'd0) && (cycle_subcount == 10'd999))
                    next_state = DONE_WAIT;
            end

            DONE_WAIT: begin
                // Wait for user acknowledgment before returning to search
                if (ack)
                    next_state = SEARCH;
            end

            default: next_state = SEARCH;
        endcase
    end

endmodule