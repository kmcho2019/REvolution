module TopModule (
    input  clk,
    input  reset,    // synchronous active-high reset
    input  data,
    output reg [3:0] count,
    output reg       counting,
    output reg       done,
    input  ack
);

    // State encoding (one-hot style for clarity)
    localparam SEARCH      = 4'b0001;
    localparam SHIFT_DELAY = 4'b0010;
    localparam COUNTING    = 4'b0100;
    localparam DONE_STATE  = 4'b1000;

    reg [3:0] state, next_state;

    // Shift register to detect start pattern 1101
    reg [3:0] pattern_shift;

    // Shift register to shift in delay bits MSB first
    reg [3:0] delay_shift;
    reg [2:0] delay_bit_count; // counts 0 to 4 bits shifted

    // Loaded delay value, controls counting
    reg [3:0] delay_value;

    // Count down ticks (delay_value+1 ticks)
    reg [3:0] remaining_ticks;

    // 12-bit cycle counter counts to 999 for each tick
    reg [11:0] cycle_counter;

    // Detect pattern 1101 on pattern_shift
    wire pattern_detected = (pattern_shift == 4'b1101);

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                if (pattern_detected)
                    next_state = SHIFT_DELAY;
            end

            SHIFT_DELAY: begin
                if (delay_bit_count == 4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // when remaining_ticks is 0 and cycle_counter reaches 999,
                // counting is done
                if ((remaining_ticks == 0) && (cycle_counter == 12'd999))
                    next_state = DONE_STATE;
            end

            DONE_STATE: begin
                if (ack)
                    next_state = SEARCH;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay_shift <= 4'b0000;
            delay_bit_count <= 0;
            delay_value <= 0;
            remaining_ticks <= 0;
            cycle_counter <= 0;
            counting <= 0;
            done <= 0;
            count <= 4'd0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    done <= 0;
                    counting <= 0;
                    count <= 4'd0;   // don't care, assign 0 for stability

                    // Shift pattern detector with new data bit
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay bit count and delay shift reg, preparing for next
                    delay_bit_count <= 0;
                    delay_shift <= 4'b0000;

                    // Clear counters
                    delay_value <= 0;
                    remaining_ticks <= 0;
                    cycle_counter <= 0;
                end

                SHIFT_DELAY: begin
                    done <= 0;
                    counting <= 0;
                    count <= 4'd0;   // don't care, assign 0

                    // Do NOT shift pattern_shift here - we are ignoring pattern detection in this phase

                    // Shift in delay bits MSB first
                    delay_shift <= {delay_shift[2:0], data};
                    delay_bit_count <= delay_bit_count + 1;

                    // On the last bit shifted (bit 4), latch delay_value and remaining_ticks
                    if (delay_bit_count == 3) begin
                        delay_value <= {delay_shift[2:0], data};
                        remaining_ticks <= {delay_shift[2:0], data};
                        cycle_counter <= 0;
                    end
                end

                COUNTING: begin
                    done <= 0;
                    counting <= 1;
                    count <= remaining_ticks;

                    // Hold pattern_shift and delay_shift as-is, unused here
                    pattern_shift <= pattern_shift;
                    delay_shift <= delay_shift;
                    delay_bit_count <= delay_bit_count;

                    // Counting logic: count 1000 cycles per tick, decrement remaining_ticks accordingly
                    if (cycle_counter == 12'd999) begin
                        cycle_counter <= 0;
                        if (remaining_ticks != 0)
                            remaining_ticks <= remaining_ticks - 1;
                        else
                            remaining_ticks <= 0; // safe guard
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                end

                DONE_STATE: begin
                    done <= 1;
                    counting <= 0;
                    count <= 4'd0; // don't care, assign 0

                    // Hold pattern_shift and delay_shift constant (not used)
                    pattern_shift <= pattern_shift;
                    delay_shift <= delay_shift;
                    delay_bit_count <= 0;

                    delay_value <= 0;
                    remaining_ticks <= 0;
                    cycle_counter <= 0;
                end

                default: begin
                    // Defensive reset to SEARCH in case of unknown state
                    state <= SEARCH;
                    pattern_shift <= 4'b0000;
                    delay_shift <= 4'b0000;
                    delay_bit_count <= 0;
                    delay_value <= 0;
                    remaining_ticks <= 0;
                    cycle_counter <= 0;
                    counting <= 0;
                    done <= 0;
                    count <= 4'd0;
                end
            endcase
        end
    end
endmodule