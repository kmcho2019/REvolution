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

    // Continuous pattern shift register for pattern detection (MSB oldest)
    reg [3:0] pattern_shift;

    // Delay bits loading
    reg [2:0] load_bits_cnt;      // counts 0..4 for 4 delay bits loaded
    reg [3:0] delay_reg;

    // Counting counters
    reg [9:0] cycle_subcount;     // counts 0..999 cycles per 1000 cycle block
    reg [4:0] remaining_ticks;    // 5 bits to hold delay+1 (max 16)

    // --- Continuous pattern shift register ---
    // This shift happens every clock cycle, independent of FSM state
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift <= 4'b0000;
        end else begin
            pattern_shift <= {pattern_shift[2:0], data};
        end
    end

    // --- FSM state register ---
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
        end else begin
            state <= next_state;
        end
    end

    // --- Main sequential logic for registers and outputs ---
    always @(posedge clk) begin
        if (reset) begin
            load_bits_cnt   <= 3'd0;
            delay_reg       <= 4'd0;
            cycle_subcount  <= 10'd0;
            remaining_ticks <= 5'd0;
            count           <= 4'd0;
            counting        <= 1'b0;
            done            <= 1'b0;
        end else begin
            case(state)
                SEARCH: begin
                    // Clear registers related to delay loading and counting
                    load_bits_cnt   <= 3'd0;
                    delay_reg       <= 4'd0;
                    cycle_subcount  <= 10'd0;
                    remaining_ticks <= 5'd0;

                    // Outputs
                    counting <= 1'b0;
                    done     <= 1'b0;
                    // count is don't care when not counting, assign 0
                    count <= 4'd0;
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB first: shift left and insert new bit at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    load_bits_cnt <= load_bits_cnt + 1'b1;

                    // Outputs stable
                    counting <= 1'b0;
                    done <= 1'b0;
                    cycle_subcount <= 10'd0;
                    remaining_ticks <= 5'd0;
                    count <= 4'd0;
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // cycle_subcount increments each clock
                    if (cycle_subcount == 10'd999) begin
                        cycle_subcount <= 10'd0;
                        // Decrement remaining_ticks at the end of each 1000-cycle block if not zero
                        if (remaining_ticks != 5'd0)
                            remaining_ticks <= remaining_ticks - 1'b1;
                    end else begin
                        cycle_subcount <= cycle_subcount + 1'b1;
                    end

                    // Output the current remaining_ticks as count (4 LSBs)
                    // Output holds stable for full 1000-cycle block
                    count <= remaining_ticks[3:0];

                    // Keep load_bits_cnt and delay_reg stable during counting (not used)
                    // They retain their last values by default (no change)
                end

                DONE_WAIT: begin
                    // Wait for ack, indicate done
                    counting <= 1'b0;
                    done <= 1'b1;

                    // Clear counters for next time
                    load_bits_cnt   <= 3'd0;
                    delay_reg       <= 4'd0;
                    cycle_subcount  <= 10'd0;
                    remaining_ticks <= 5'd0;

                    // count is don't care here, set to 0
                    count <= 4'd0;
                end

                default: begin
                    // Defensive default to SEARCH state and clears
                    load_bits_cnt   <= 3'd0;
                    delay_reg       <= 4'd0;
                    cycle_subcount  <= 10'd0;
                    remaining_ticks <= 5'd0;
                    count           <= 4'd0;
                    counting        <= 1'b0;
                    done            <= 1'b0;
                end
            endcase

            // Load remaining_ticks when transitioning from LOAD_DELAY to COUNTING
            // This is done synchronously on the clock edge of transition
            if (state == LOAD_DELAY && next_state == COUNTING) begin
                remaining_ticks <= {1'b0, delay_reg} + 5'd1; // delay + 1
                cycle_subcount <= 10'd0; // reset cycle_subcount at start counting
            end
        end
    end

    // --- Next state logic ---
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                // Transition to LOAD_DELAY when pattern detected
                // pattern_shift is updated synchronously and available here
                if (pattern_shift == 4'b1101) begin
                    next_state = LOAD_DELAY;
                end
            end

            LOAD_DELAY: begin
                // After loading 4 delay bits, go to COUNTING
                if (load_bits_cnt == 3'd4) begin
                    next_state = COUNTING;
                end
            end

            COUNTING: begin
                // When all 1000-cycle blocks are counted (remaining_ticks == 0 at end of block)
                // Wait for completion of current 1000-cycle block cycle_subcount == 999
                if (remaining_ticks == 5'd0 && cycle_subcount == 10'd999) begin
                    next_state = DONE_WAIT;
                end
            end

            DONE_WAIT: begin
                // Wait for user ack to restart searching
                if (ack) begin
                    next_state = SEARCH;
                end
            end

            default: begin
                next_state = SEARCH;
            end
        endcase
    end

endmodule