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

    // Pattern detection shift register: oldest bit at MSB, newest bit at LSB
    // Shift right each cycle, insert new data bit at MSB
    reg [3:0] pattern_shift;

    // Delay register and counter for loading 4 bits
    reg [3:0] delay;
    reg [2:0] delay_bits_loaded;  // counts 0..4 bits loaded

    // Counters for counting phase
    reg [9:0] cycle_counter;      // counts down 999..0 cycles per segment
    reg [3:0] segment_counter;    // counts down segments remaining (delay+1..0)

    // Pattern detected when pattern_shift == 1101
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

    // Sequential logic: state, pattern_shift, counters, outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay <= 4'b0000;
            delay_bits_loaded <= 3'd0;
            cycle_counter <= 10'd0;
            segment_counter <= 4'd0;
            count <= 4'bxxxx;       // don't care when not counting
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift in new data bit at MSB, shift right by one
                    // pattern_shift[3] = oldest, pattern_shift[0] = newest bit
                    // Insert new bit at MSB, so pattern_shift <= {data, pattern_shift[3:1]};
                    pattern_shift <= {data, pattern_shift[3:1]};

                    // Reset delay loading registers and counters
                    delay <= 4'b0000;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;

                    count <= 4'bxxxx; // don't care
                end

                LOAD_DELAY: begin
                    // Shift delay left by 1, insert new bit at LSB (MSB first loading)
                    // The first received bit goes to delay[3]
                    delay <= {delay[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;

                    // Hold pattern_shift stable during LOAD_DELAY
                    pattern_shift <= pattern_shift;

                    // Reset counting and done signals during loading
                    counting <= 1'b0;
                    done <= 1'b0;

                    count <= 4'bxxxx; // don't care

                    // Counters hold zero here
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                end

                COUNT: begin
                    // Hold pattern_shift stable during counting
                    pattern_shift <= pattern_shift;

                    // Counting active, done cleared
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Detect entry into COUNT state to initialize counters:
                    // Initialize counters once at COUNT state entry:
                    // Use prior state comparison: initialize if previous state != COUNT
                    if (state != COUNT) begin
                        // Initialize segment_counter to delay+1 segments
                        segment_counter <= delay + 1'b1;
                        // Initialize cycle_counter to 999 for 1000 cycles counting down
                        cycle_counter <= 10'd999;

                        // Output count is initially delay+1 segments
                        count <= delay + 1'b1;
                    end else begin
                        // Normal counting operation:
                        if (cycle_counter == 0) begin
                            // Completed one 1000-cycle segment
                            if (segment_counter > 0) begin
                                segment_counter <= segment_counter - 1'b1;
                            end

                            if (segment_counter > 1) begin
                                // Start next segment counting cycles from 999
                                cycle_counter <= 10'd999;
                            end else if (segment_counter == 1) begin
                                // Last segment counting completed, cycle_counter set to 0
                                cycle_counter <= 10'd0;
                            end else begin
                                // Counting complete: both counters zero
                                cycle_counter <= 10'd0;
                            end
                        end else begin
                            // Count down cycle_counter normally
                            cycle_counter <= cycle_counter - 1'b1;
                        end

                        // Output count reflects the segments remaining minus 1 during current segment counting:
                        // The count output stays constant for the whole 1000 cycles segment,
                        // decrementing only when a segment completes.

                        // If cycle_counter == 0 means end of segment counting, so count = segment_counter
                        // Else count = segment_counter - 1 (current segment)
                        if (cycle_counter == 0) begin
                            count <= segment_counter;
                        end else begin
                            count <= (segment_counter > 0) ? (segment_counter - 1'b1) : 4'd0;
                        end
                    end
                end

                WAIT_ACK: begin
                    // Hold pattern_shift stable
                    pattern_shift <= pattern_shift;

                    // Signal done, counting inactive
                    done <= 1'b1;
                    counting <= 1'b0;

                    // count don't care here
                    count <= 4'bxxxx;

                    // Reset counters to zero
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                    delay_bits_loaded <= delay_bits_loaded;
                    delay <= delay;
                end

                default: begin
                    // Safe reset values on invalid state
                    state <= SEARCH;
                    pattern_shift <= 4'b0000;
                    delay <= 4'b0000;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                    count <= 4'bxxxx;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule