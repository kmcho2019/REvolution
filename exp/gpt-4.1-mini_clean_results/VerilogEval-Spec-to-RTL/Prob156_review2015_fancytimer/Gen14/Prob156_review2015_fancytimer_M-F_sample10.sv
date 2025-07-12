module TopModule (
    input  wire       clk,
    input  wire       reset,  // synchronous active-high reset
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // State encoding: one-hot style can be replaced by simple binary for clarity
    typedef enum logic [1:0] {
        STATE_SEARCH     = 2'b00,
        STATE_LOAD_DELAY = 2'b01,
        STATE_COUNT      = 2'b10,
        STATE_DONE       = 2'b11
    } state_t;

    state_t state, next_state;

    // Pattern detection register (4 bits) - shift in MSB first: shift left and insert data at LSB
    reg [3:0] pattern_reg;

    // Delay bits loading register (4 bits)
    reg [3:0] delay_reg;
    reg [2:0] delay_bit_cnt; // counts from 0 to 4 inclusive

    // Cycle counter: counts down from (delay+1)*1000 - 1 down to 0
    // Max cycles = (15+1)*1000 = 16000 => needs 15 bits, use 14 bits as 2^14=16384 > 16000
    reg [13:0] cycle_counter;

    // Segment count: counts how many 1000-cycle segments remain (from delay down to 0)
    reg [3:0] segment_count;

    // Detect segment boundary: cycle_counter low 10 bits == 0 means segment finished
    wire segment_done = (cycle_counter[9:0] == 10'd0);

    // Pattern found: pattern_reg == 4'b1101
    wire pattern_found = (pattern_reg == 4'b1101);

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case (state)
            STATE_SEARCH: begin
                if (pattern_found)
                    next_state = STATE_LOAD_DELAY;
            end
            STATE_LOAD_DELAY: begin
                if (delay_bit_cnt == 3'd4)
                    next_state = STATE_COUNT;
            end
            STATE_COUNT: begin
                if ((segment_done) && (segment_count == 0))
                    next_state = STATE_DONE;
            end
            STATE_DONE: begin
                if (ack)
                    next_state = STATE_SEARCH;
            end
            default: next_state = STATE_SEARCH; // safe default
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_SEARCH;
            pattern_reg <= 4'b0000;
            delay_reg <= 4'b0000;
            delay_bit_cnt <= 3'd0;
            cycle_counter <= 14'd0;
            segment_count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            // State update
            state <= next_state;

            case (state)
                STATE_SEARCH: begin
                    // Shift pattern left, insert new data bit at LSB (MSB first arrival)
                    pattern_reg <= {pattern_reg[2:0], data};

                    // Clear delay registers and counters to avoid stale data
                    delay_reg <= 4'b0000;
                    delay_bit_cnt <= 3'd0;

                    cycle_counter <= 14'd0;
                    segment_count <= 4'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                STATE_LOAD_DELAY: begin
                    // Shift delay bits in MSB first: shift left and insert data at LSB
                    // delay_reg[3] is MSB first bit shifted in first
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bit_cnt <= delay_bit_cnt + 1'b1;

                    // Hold pattern stable
                    pattern_reg <= pattern_reg;

                    // No counting in this state
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;

                    cycle_counter <= 14'd0;
                    segment_count <= 4'd0;
                end

                STATE_COUNT: begin
                    // Hold pattern and delay stable
                    pattern_reg <= pattern_reg;
                    delay_reg <= delay_reg;
                    delay_bit_cnt <= delay_bit_cnt;

                    counting <= 1'b1;
                    done <= 1'b0;

                    // On state entry (detect previous state), initialize counters
                    // To detect state entry, store prev state in a register or use a signal
                    // We detect entry by previous state != STATE_COUNT

                    // We can implement entry detection by a register or checking if cycle_counter == 0 (initial)
                    // Let's implement entry detection using a latch of previous state:
                end

                STATE_DONE: begin
                    // Hold registers stable
                    pattern_reg <= pattern_reg;
                    delay_reg <= delay_reg;
                    delay_bit_cnt <= delay_bit_cnt;
                    cycle_counter <= 14'd0;
                    segment_count <= 4'd0;

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0; // output stable value when done
                end

                default: begin
                    // Safety fallback
                    pattern_reg <= 4'b0000;
                    delay_reg <= 4'b0000;
                    delay_bit_cnt <= 3'd0;
                    cycle_counter <= 14'd0;
                    segment_count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
            endcase
        end
    end

    // To detect state entry for STATE_COUNT, create a register to hold previous state
    reg [1:0] prev_state;
    always @(posedge clk) begin
        if (reset) begin
            prev_state <= STATE_SEARCH;
        end else begin
            prev_state <= state;
        end
    end

    // Cycle and segment counters logic, separated for clarity
    always @(posedge clk) begin
        if (reset) begin
            cycle_counter <= 14'd0;
            segment_count <= 4'd0;
            count <= 4'd0;
        end else if (state == STATE_COUNT) begin
            // On entry to STATE_COUNT initialize counters
            if (prev_state != STATE_COUNT) begin
                // total cycles = (delay + 1)*1000 cycles, counting down from total-1
                // segment_count starts at delay (number of full segments left)
                cycle_counter <= ((delay_reg + 1'b1) * 14'd1000) - 14'd1;
                segment_count <= delay_reg;
                count <= delay_reg;
            end else begin
                if (cycle_counter != 14'd0) begin
                    cycle_counter <= cycle_counter - 14'd1;
                end

                // At segment boundary (every 1000 cycles), decrement segment_count if > 0
                // segment_done = cycle_counter low 10 bits == 0
                // To avoid multiple decrements on the same cycle, decrement segment_count only when segment_done and segment_count > 0
                if (segment_done && (segment_count != 0)) begin
                    segment_count <= segment_count - 1'b1;
                end

                count <= segment_count;
            end
        end else begin
            // Not counting, hold count stable or clear
            count <= 4'd0;
            cycle_counter <= 14'd0;
            segment_count <= 4'd0;
        end
    end

endmodule