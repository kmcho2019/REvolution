module TopModule (
    input  wire       clk,
    input  wire       reset,  // synchronous active-high reset
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // State encoding: one-hot style for clarity
    localparam STATE_SEARCH       = 3'b001;
    localparam STATE_LOAD_DELAY   = 3'b010;
    localparam STATE_COUNT        = 3'b100;
    localparam STATE_DONE         = 3'b000; // encoded separately in reg for convenience

    // Using a 2-bit FSM (one-hot for 3 states and special done state in code)
    reg [2:0] state;
    reg [2:0] next_state;

    // Pattern detection register (4 bits)
    reg [3:0] pattern_reg;

    // Delay bits loading register (4 bits)
    reg [3:0] delay_reg;
    reg [2:0] delay_bit_cnt; // 0..4 bits loaded

    // Total cycle count: (delay+1)*1000 cycles
    // Max delay is 4 bits = 15, max cycles = (15+1)*1000=16000 cycles => need 15 bits
    reg [13:0] total_cycles;       // 14 bits to hold up to 16000 safely (actually need 14 bits for max 16000)
    reg [13:0] cycle_counter;

    // Remaining segments count: counts how many 1000-cycle segments remain
    // Counts down from delay to 0, output count=segment_count
    reg [3:0] segment_count;

    // Synchronize and detect end of 1000-cycle segments
    wire segment_done = (cycle_counter == 14'd0);

    // Pattern 1101 detection is done in SEARCH state only
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
                if (segment_done && (segment_count == 0))
                    next_state = STATE_DONE;
            end
            default: begin
                // STATE_DONE
                if (ack)
                    next_state = STATE_SEARCH;
            end
        endcase
    end

    // Sequential logic: state, pattern shift, delay loading, counters, outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_SEARCH;
            pattern_reg <= 4'b0000;
            delay_reg <= 4'b0000;
            delay_bit_cnt <= 3'd0;
            total_cycles <= 14'd0;
            cycle_counter <= 14'd0;
            segment_count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0000;
        end else begin
            state <= next_state;

            case (state)
                STATE_SEARCH: begin
                    // Shift in new data only in SEARCH to detect pattern 1101
                    // Shift left by 1, insert data at LSB
                    // According to the spec, pattern detection is 1101, this works for that
                    pattern_reg <= {pattern_reg[2:0], data};

                    // Reset delay loading registers
                    delay_reg <= 4'b0000;
                    delay_bit_cnt <= 3'd0;

                    total_cycles <= 14'd0;
                    cycle_counter <= 14'd0;
                    segment_count <= 4'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx; // don't-care during search, 'x' to emphasize don't care
                end

                STATE_LOAD_DELAY: begin
                    // During load_delay, do not shift pattern_reg, hold it constant
                    pattern_reg <= pattern_reg;

                    // Shift in data bits MSB-first: shift right, insert at MSB
                    // This matches the requirement to shift in MSB first.
                    delay_reg <= {delay_reg[2:1], data};
                    delay_bit_cnt <= delay_bit_cnt + 1'b1;

                    // Hold counters and outputs off
                    total_cycles <= 14'd0;
                    cycle_counter <= 14'd0;
                    segment_count <= 4'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                end

                STATE_COUNT: begin
                    pattern_reg <= pattern_reg; // hold pattern

                    delay_reg <= delay_reg;
                    delay_bit_cnt <= delay_bit_cnt;

                    counting <= 1'b1;
                    done <= 1'b0;

                    // Initialize total_cycles and segment_count at state entry (detected on transition)
                    if (next_state != STATE_COUNT) begin
                        // Prepare counters for next state COUNT
                        // This condition won't be true here; init done below
                    end

                    // If just entered COUNT state this cycle (from LOAD_DELAY)
                    if ((next_state == STATE_COUNT) && (state == STATE_LOAD_DELAY) && (delay_bit_cnt == 3'd4)) begin
                        // total cycles = (delay + 1) * 1000
                        total_cycles <= (delay_reg + 1'b1) * 14'd1000;
                        cycle_counter <= (delay_reg + 1'b1) * 14'd1000 - 14'd1; // countdown from total_cycles-1
                        segment_count <= delay_reg;
                        count <= delay_reg;
                    end else begin
                        // Count down cycle_counter every clock
                        if (cycle_counter != 14'd0) begin
                            cycle_counter <= cycle_counter - 14'd1;
                        end

                        // At the end of each 1000-cycle segment, decrement segment_count
                        // segment_done is when cycle_counter % 1000 == 0
                        // Since we count down, detect when low 10 bits == 999 -> 0 corresponded 
                        // But simpler: check bits[9:0] == 0 to mark segment boundary
                        if ((cycle_counter[9:0] == 10'd999) || (cycle_counter[9:0] == 10'd0)) begin
                            if (segment_count != 0)
                                segment_count <= segment_count - 1'b1;
                        end

                        count <= segment_count;
                    end
                end

                default: begin
                    // DONE state:
                    // Holding pattern_reg and delay_reg steady
                    pattern_reg <= pattern_reg;
                    delay_reg <= delay_reg;
                    delay_bit_cnt <= delay_bit_cnt;

                    total_cycles <= 14'd0;
                    cycle_counter <= 14'd0;
                    segment_count <= 4'd0;

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'bxxxx; // don't care done state
                end
            endcase
        end
    end

endmodule