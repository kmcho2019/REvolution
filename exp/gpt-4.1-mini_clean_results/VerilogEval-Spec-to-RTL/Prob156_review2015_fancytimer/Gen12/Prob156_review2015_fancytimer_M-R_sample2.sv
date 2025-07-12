module TopModule (
    input  wire       clk,
    input  wire       reset,  // synchronous active-high reset
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // State encoding
    localparam SEARCH        = 2'd0;
    localparam LOAD_DELAY    = 2'd1;
    localparam COUNT         = 2'd2;
    localparam DONE_WAIT_ACK = 2'd3;

    reg [1:0] state, state_next;

    // Pattern shift register (4 bits) for detecting 1101
    reg [3:0] pattern_shift;

    // Delay loading registers
    reg [3:0] delay_reg;
    reg [2:0] delay_bit_cnt; // counts 0..4 bits loaded

    // Counting registers
    reg [3:0] segment_count;    // counts down from delay to 0
    reg [9:0] cycle_counter;    // counts 0..999 cycles per segment

    // Detect pattern found combinationally
    wire pattern_found = (pattern_shift == 4'b1101);

    // Next state logic combinational
    always @(*) begin
        state_next = state;
        case (state)
            SEARCH: begin
                if (pattern_found)
                    state_next = LOAD_DELAY;
            end
            LOAD_DELAY: begin
                if (delay_bit_cnt == 3'd4)
                    state_next = COUNT;
            end
            COUNT: begin
                // When segment_count == 0 and last cycle of segment finished
                if ((segment_count == 4'd0) && (cycle_counter == 10'd999))
                    state_next = DONE_WAIT_ACK;
            end
            DONE_WAIT_ACK: begin
                if (ack)
                    state_next = SEARCH;
            end
        endcase
    end

    // Synchronous process for state, counters, pattern shift, delay loading, counting
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay_reg <= 4'b0000;
            delay_bit_cnt <= 3'd0;
            segment_count <= 4'd0;
            cycle_counter <= 10'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            state <= state_next;

            case (state)
                SEARCH: begin
                    // Shift in data bit to pattern_shift register for pattern detection
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_reg <= 4'b0000;
                    delay_bit_cnt <= 3'd0;
                    segment_count <= 4'd0;
                    cycle_counter <= 10'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
                LOAD_DELAY: begin
                    // Shift in data bit MSB first: shift left, insert data at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bit_cnt <= delay_bit_cnt + 1'b1;

                    pattern_shift <= pattern_shift; // hold pattern_shift constant

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    segment_count <= 4'd0;
                    cycle_counter <= 10'd0;
                end
                COUNT: begin
                    // Hold pattern_shift constant (don't shift during counting)
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bit_cnt <= delay_bit_cnt;

                    counting <= 1'b1;
                    done <= 1'b0;

                    // Count cycles in each 1000-cycle segment
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        // Decrement segment count at end of segment
                        if (segment_count != 0)
                            segment_count <= segment_count - 1'b1;
                        else
                            segment_count <= 4'd0; // should not go below zero
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end

                    // Output current segment_count as count
                    count <= segment_count;
                end
                DONE_WAIT_ACK: begin
                    // Hold pattern_shift constant
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bit_cnt <= delay_bit_cnt;
                    segment_count <= segment_count;
                    cycle_counter <= cycle_counter;

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;  // don't care in done state
                end
                default: begin
                    // Safety defaults
                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'b0000;
                    delay_bit_cnt <= 3'd0;
                    segment_count <= 4'd0;
                    cycle_counter <= 10'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
            endcase

            // Load segment_count with delay at start of COUNT state:
            // Detect rising edge from LOAD_DELAY to COUNT to load segment_count = delay_reg
            if ((state == LOAD_DELAY) && (delay_bit_cnt == 3'd4) && (state_next == COUNT)) begin
                segment_count <= delay_reg;
                cycle_counter <= 10'd0;
                count <= delay_reg;
            end

            // Reset pattern_shift only in SEARCH, no other changes needed here
        end
    end

endmodule