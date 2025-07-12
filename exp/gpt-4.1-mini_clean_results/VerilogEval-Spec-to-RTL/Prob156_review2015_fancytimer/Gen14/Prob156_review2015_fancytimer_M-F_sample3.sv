module TopModule (
    input  wire       clk,
    input  wire       reset,  // synchronous active-high reset
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // FSM states - binary encoding
    localparam STATE_SEARCH     = 3'd0;
    localparam STATE_LOAD_DELAY = 3'd1;
    localparam STATE_COUNT      = 3'd2;
    localparam STATE_DONE       = 3'd3;

    reg [2:0] state, next_state;

    // Pattern detection shift register for 1101 detection (4 bits)
    // Shift left, inserting new bit at LSB: so MSB is oldest bit
    // This way, after shifting 4 bits, pattern_reg[3:0] holds last 4 data bits MSB-first
    reg [3:0] pattern_reg;

    // Delay register (4 bits), MSB-first shifting:
    // shift left inserting new bit at LSB, so first bit shifted is delay[3]
    reg [3:0] delay_reg;
    reg [2:0] delay_bit_cnt; // counts 0 to 4 bits shifted

    // Counter for total clock cycles (14 bits sufficient for max 16,000 cycles)
    reg [13:0] cycle_counter;

    // Counter for counting 1000-cycle segments remaining (from delay down to 0)
    reg [3:0] segment_count;

    // 10-bit cycle subcounter counting 0 to 999 cycles for each segment
    reg [9:0] segment_cycle_counter;

    // Previous state register for detecting state transitions
    reg [2:0] state_d;

    // Signals for convenience
    wire pattern_found = (pattern_reg == 4'b1101);
    wire segment_cycle_done = (segment_cycle_counter == 10'd999);
    wire counting_done = (segment_count == 4'd0) && segment_cycle_done;

    // FSM combinational next state logic
    always @(*) begin
        case (state)
            STATE_SEARCH: 
                next_state = pattern_found ? STATE_LOAD_DELAY : STATE_SEARCH;

            STATE_LOAD_DELAY:
                next_state = (delay_bit_cnt == 3'd4) ? STATE_COUNT : STATE_LOAD_DELAY;

            STATE_COUNT:
                next_state = counting_done ? STATE_DONE : STATE_COUNT;

            STATE_DONE:
                next_state = ack ? STATE_SEARCH : STATE_DONE;

            default:
                next_state = STATE_SEARCH;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_SEARCH;
            state_d <= STATE_SEARCH;

            pattern_reg <= 4'b0000;

            delay_reg <= 4'b0000;
            delay_bit_cnt <= 3'd0;

            cycle_counter <= 14'd0;
            segment_count <= 4'd0;
            segment_cycle_counter <= 10'd0;

            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0000;
        end else begin
            state <= next_state;
            state_d <= state; // delayed state for edge detection

            // Default assignments (hold by default, update per state below)
            case (state)
                STATE_SEARCH: begin
                    // Shift pattern register left, insert new data bit at LSB
                    // Oldest bit at MSB, newest at LSB: pattern_reg[3:0] = last 4 bits MSB-first
                    pattern_reg <= {pattern_reg[2:0], data};

                    // Reset delay loading registers
                    delay_reg <= 4'b0000;
                    delay_bit_cnt <= 3'd0;

                    // Reset counters
                    cycle_counter <= 14'd0;
                    segment_count <= 4'd0;
                    segment_cycle_counter <= 10'd0;

                    // Outputs
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000; // Stable zero in non-counting states
                end

                STATE_LOAD_DELAY: begin
                    // Hold pattern_reg steady (don't shift during delay load)
                    pattern_reg <= pattern_reg;

                    // Shift delay bits left inserting new bit at LSB:
                    // First bit loaded becomes delay[3], matching MSB-first shift-in
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bit_cnt <= delay_bit_cnt + 1'b1;

                    // Counters stay reset here
                    cycle_counter <= 14'd0;
                    segment_count <= 4'd0;
                    segment_cycle_counter <= 10'd0;

                    // Outputs
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                end

                STATE_COUNT: begin
                    // Hold pattern_reg and delay_reg steady
                    pattern_reg <= pattern_reg;
                    delay_reg <= delay_reg;
                    delay_bit_cnt <= delay_bit_cnt;

                    counting <= 1'b1;
                    done <= 1'b0;

                    // On entry to COUNT state, initialize counters
                    if (state_d == STATE_LOAD_DELAY) begin
                        // Total cycles = (delay + 1) * 1000 cycles
                        cycle_counter <= (delay_reg + 1) * 14'd1000 - 14'd1;
                        segment_count <= delay_reg;
                        segment_cycle_counter <= 10'd0;
                        count <= delay_reg;
                    end else begin
                        // Decrement cycle counter every clock
                        if (cycle_counter != 14'd0)
                            cycle_counter <= cycle_counter - 1;

                        // Increment segment_cycle_counter (0 to 999)
                        if (segment_cycle_counter == 10'd999)
                            segment_cycle_counter <= 10'd0;
                        else
                            segment_cycle_counter <= segment_cycle_counter + 1;

                        // Decrement segment_count at end of each 1000 cycle segment
                        if ((segment_cycle_counter == 10'd999) && (segment_count != 0))
                            segment_count <= segment_count - 1;

                        // Update output count to remaining segments
                        count <= segment_count;
                    end
                end

                STATE_DONE: begin
                    // Hold pattern_reg and delay_reg steady
                    pattern_reg <= pattern_reg;
                    delay_reg <= delay_reg;
                    delay_bit_cnt <= delay_bit_cnt;

                    // Reset counters and subcounters
                    cycle_counter <= 14'd0;
                    segment_count <= 4'd0;
                    segment_cycle_counter <= 10'd0;

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0000; // stable zero in done state
                end

                default: begin
                    // Should never get here; safe defaults
                    pattern_reg <= 4'b0000;
                    delay_reg <= 4'b0000;
                    delay_bit_cnt <= 3'd0;

                    cycle_counter <= 14'd0;
                    segment_count <= 4'd0;
                    segment_cycle_counter <= 10'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                end
            endcase
        end
    end

endmodule