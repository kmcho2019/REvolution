module TopModule (
    input  wire       clk,
    input  wire       reset,  // synchronous active-high reset
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // State encoding with parameters instead of enums
    localparam SEARCH     = 2'd0;
    localparam LOAD_DELAY = 2'd1;
    localparam COUNT      = 2'd2;
    localparam WAIT_ACK   = 2'd3;

    reg [1:0] state, next_state;

    // Shift register for pattern detection (stores last 4 bits, MSB is newest bit)
    reg [3:0] pattern_shift;

    // Delay loading registers
    reg [3:0] delay;
    reg [2:0] delay_bits_loaded; // counts 0..4 bits loaded

    // Counting registers
    reg [9:0] cycle_counter;    // counts 0..999
    reg [3:0] segment_counter;  // counts down from delay+1 to 0

    // Combinational pattern match
    wire pattern_found = (pattern_shift == 4'b1101);

    integer i;

    // Next state logic and outputs combinational
    always @(*) begin
        // Default next state holds current state
        next_state = state;

        case(state)
            SEARCH: begin
                if (pattern_found)
                    next_state = LOAD_DELAY;
            end
            LOAD_DELAY: begin
                if (delay_bits_loaded == 3'd4)
                    next_state = COUNT;
            end
            COUNT: begin
                // Done counting when segment_counter and cycle_counter both zero
                if ((segment_counter == 0) && (cycle_counter == 0))
                    next_state = WAIT_ACK;
            end
            WAIT_ACK: begin
                if (ack)
                    next_state = SEARCH;
            end
            default: next_state = SEARCH;
        endcase
    end

    // Sequential logic: state, counters, pattern shift, and outputs
    always @(posedge clk) begin
        if (reset) begin
            // Reset all registers
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay <= 4'b0000;
            delay_bits_loaded <= 3'd0;
            cycle_counter <= 10'd0;
            segment_counter <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0000;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Update pattern shift register with new data bit at LSB (MSB-first means newest bit shifted in at LSB?)
                    // Note original states insert new bit at MSB. To keep consistent:
                    // Since pattern_shift[3] is oldest, [0] newest, shift right and insert new bit at MSB:
                    // But problem states MSB-first, so newest bit at MSB
                    // We'll shift left and insert data at LSB:
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay <= 4'b0000;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                end

                LOAD_DELAY: begin
                    // Shift delay register left, insert data bit at LSB (MSB-first)
                    delay <= {delay[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;
                    // Keep pattern_shift stable (don't update during LOAD_DELAY)
                    pattern_shift <= pattern_shift;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                end

                COUNT: begin
                    pattern_shift <= pattern_shift; // hold pattern_shift stable
                    delay_bits_loaded <= delay_bits_loaded;

                    counting <= 1'b1;
                    done <= 1'b0;

                    if (cycle_counter == 0) begin
                        // If starting counting or just finished a segment of 1000 cycles
                        if (segment_counter == 0) begin
                            // Counting done - next_state will move to WAIT_ACK
                            counting <= 1'b0;
                            cycle_counter <= 10'd0;
                            count <= 4'b0000;
                        end else begin
                            // Start a new 1000-cycle segment
                            cycle_counter <= 10'd999;
                            // Decrement segment counter at the start of the segment, except for first segment start
                            // So segment_counter decremented here unless this is the first count cycle
                            // To detect first cycle after entering COUNT:
                            // On entry to COUNT state, segment_counter is initialized, decrement here each new segment start except first
                            if (segment_counter == (delay + 1'b1)) begin
                                // First segment start, no decrement
                                segment_counter <= segment_counter;
                            end else begin
                                segment_counter <= segment_counter - 1'b1;
                            end
                        end
                    end else begin
                        // Continue counting down cycle_counter
                        cycle_counter <= cycle_counter - 1'b1;
                    end

                    // Update count output to show remaining segment count during the 1000 cycle segment
                    // count = segment_counter - 1 during counting cycles (cycle_counter > 0), else segment_counter
                    if (cycle_counter == 0) begin
                        count <= segment_counter;
                    end else begin
                        if (segment_counter > 0)
                            count <= segment_counter - 1'b1;
                        else
                            count <= 4'd0;
                    end
                end

                WAIT_ACK: begin
                    // Signal done, wait for ack
                    done <= 1'b1;
                    counting <= 1'b0;
                    count <= 4'b0000;
                    pattern_shift <= pattern_shift;
                    delay <= delay;
                    delay_bits_loaded <= delay_bits_loaded;
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                end

                default: begin
                    // Default safe values
                    state <= SEARCH;
                    pattern_shift <= 4'b0000;
                    delay <= 4'b0000;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                end
            endcase

            // Initialize counters at the moment we enter COUNT state
            // Detect state transition SEARCH or LOAD_DELAY to COUNT
            if (state != COUNT && next_state == COUNT) begin
                segment_counter <= delay + 1'b1;
                cycle_counter <= 10'd999;
            end
        end
    end

endmodule