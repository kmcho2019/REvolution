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
    reg [4:0] remaining_ticks;    // to hold delay+1 safely (max 16+1=17 fits in 5 bits)

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

                    // Reset loading and counting registers
                    load_bits_cnt <= 3'd0;
                    delay_reg <= 4'd0;
                    cycle_subcount <= 10'd0;
                    remaining_ticks <= 5'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                LOAD_DELAY: begin
                    // Shift delay_reg right, insert data at MSB (MSB first loading)
                    delay_reg <= {data, delay_reg[3:1]};
                    load_bits_cnt <= load_bits_cnt + 1'b1;

                    // pattern_shift unchanged during load_delay
                    pattern_shift <= pattern_shift;

                    counting <= 1'b0;
                    done <= 1'b0;
                    cycle_subcount <= 10'd0;
                    remaining_ticks <= 5'd0;
                    count <= 4'd0;
                end

                COUNTING: begin
                    // Hold pattern_shift, load_bits_cnt, delay_reg steady
                    pattern_shift <= pattern_shift;
                    load_bits_cnt <= load_bits_cnt;
                    delay_reg <= delay_reg;

                    counting <= 1'b1;
                    done <= 1'b0;

                    if (cycle_subcount == 10'd999) begin
                        cycle_subcount <= 10'd0;
                        if (remaining_ticks != 5'd0)
                            remaining_ticks <= remaining_ticks - 1'b1;
                    end else begin
                        cycle_subcount <= cycle_subcount + 1'b1;
                    end

                    // Output count reflects remaining_ticks-1 during cycle_subcount < 999, otherwise remaining_ticks
                    // But when remaining_ticks == 0, show 0 always (done case)
                    if (remaining_ticks == 5'd0) begin
                        count <= 4'd0;
                    end else if (cycle_subcount == 10'd999) begin
                        // After decrement: count = remaining_ticks after decrement, but decremented next cycle
                        // So output stable count = remaining_ticks at cycle_subcount==999
                        count <= remaining_ticks[3:0];
                    end else begin
                        // During 0..998 cycles, count shows remaining_ticks -1
                        count <= (remaining_ticks - 5'd1)[3:0];
                    end
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
                remaining_ticks <= {1'b0, delay_reg} + 5'd1; // delay_reg + 1
                cycle_subcount <= 10'd0; // reset cycle counter at start counting
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                // Wait for pattern 1101 detected in registered pattern_shift
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                // Wait until 4 bits are loaded
                if (load_bits_cnt == 3'd4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // Counting finishes when remaining_ticks == 0 and cycle_subcount == 999 (end of last 1000-cycle block)
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