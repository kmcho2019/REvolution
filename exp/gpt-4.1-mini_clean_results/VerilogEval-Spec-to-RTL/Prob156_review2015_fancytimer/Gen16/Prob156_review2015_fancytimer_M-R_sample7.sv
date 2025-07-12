module TopModule (
    input  wire       clk,
    input  wire       reset,  // synchronous active-high reset
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // State encoding using parameters
    localparam SEARCH     = 2'd0;
    localparam LOAD_DELAY = 2'd1;
    localparam COUNT      = 2'd2;
    localparam WAIT_ACK   = 2'd3;

    reg [1:0] state, next_state;

    // 4-bit shift register for pattern detection (MSB is newest bit)
    reg [3:0] pattern_shift;

    // Delay register and counter for loading 4 bits
    reg [3:0] delay;
    reg [2:0] delay_bits_loaded;  // counts 0..4 bits loaded

    // Counters for counting phase
    reg [9:0] cycle_counter;      // counts 0..999 cycles per segment
    reg [3:0] segment_counter;    // counts segments remaining (delay+1 down to 0)

    // Pattern detection combinational
    wire pattern_found = (pattern_shift == 4'b1101);

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            SEARCH:     next_state = pattern_found ? LOAD_DELAY : SEARCH;
            LOAD_DELAY: next_state = (delay_bits_loaded == 3'd4) ? COUNT : LOAD_DELAY;
            COUNT:      next_state = (segment_counter == 0 && cycle_counter == 0) ? WAIT_ACK : COUNT;
            WAIT_ACK:   next_state = ack ? SEARCH : WAIT_ACK;
            default:    next_state = SEARCH;
        endcase
    end

    // Sequential logic: state register, pattern shift, counters, outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay <= 4'b0000;
            delay_bits_loaded <= 3'd0;
            cycle_counter <= 10'd0;
            segment_counter <= 4'd0;
            count <= 4'b0000;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift in new data bit to pattern_shift MSB-first
                    // pattern_shift[3] = oldest, so shift left by one and insert at LSB
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear loading and counters
                    delay <= 4'b0000;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                end

                LOAD_DELAY: begin
                    // Shift delay in MSB first:
                    // Shift left by 1, insert data bit at LSB
                    delay <= {delay[2:0], data};

                    // Shift in next bit count
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;

                    // No counting or done in this state
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;

                    // Pattern shift is held (no change)
                    // Counters remain 0
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                end

                COUNT: begin
                    // Pattern shift not used here, hold value
                    pattern_shift <= pattern_shift;

                    // Indicate counting active
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Initialize counters on first cycle entering COUNT
                    if (next_state != COUNT) begin
                        // First cycle of COUNT state: load counters
                        segment_counter <= delay + 1'b1;
                        cycle_counter <= 10'd999; // counting cycles from 999 down to 0
                        count <= delay + 1'b1;
                    end else begin
                        // Normal counting operation

                        if (cycle_counter == 0) begin
                            // End of 1000 cycles segment
                            if (segment_counter > 0) begin
                                segment_counter <= segment_counter - 1'b1;
                            end

                            if (segment_counter > 1) begin
                                // Start next 1000 cycle segment
                                cycle_counter <= 10'd999;
                            end else if (segment_counter == 1) begin
                                // Last segment: after this cycle_counter goes to 0 and segment_counter to 0
                                cycle_counter <= 10'd0;
                            end else begin
                                // Counting complete
                                cycle_counter <= 10'd0;
                            end
                        end else begin
                            // Count down cycle_counter
                            cycle_counter <= cycle_counter - 1'b1;
                        end

                        // Output count is segment_counter adjusted:
                        // While counting cycles in segment: count = segment_counter - 1
                        // When cycle_counter==0, count = segment_counter
                        if (cycle_counter == 0) begin
                            count <= segment_counter;
                        end else begin
                            count <= (segment_counter > 0) ? segment_counter - 1'b1 : 4'd0;
                        end
                    end
                end

                WAIT_ACK: begin
                    // Signal done, waiting for ack
                    done <= 1'b1;
                    counting <= 1'b0;
                    count <= 4'b0000;

                    // Hold registers stable
                    pattern_shift <= pattern_shift;
                    delay <= delay;
                    delay_bits_loaded <= delay_bits_loaded;
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                end

                default: begin
                    // Should not happen: reset to safe values
                    state <= SEARCH;
                    pattern_shift <= 4'b0000;
                    delay <= 4'b0000;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                    count <= 4'b0000;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule