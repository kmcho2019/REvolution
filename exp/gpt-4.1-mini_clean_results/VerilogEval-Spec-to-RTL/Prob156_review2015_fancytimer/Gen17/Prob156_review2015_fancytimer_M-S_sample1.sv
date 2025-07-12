module TopModule (
    input  wire       clk,
    input  wire       reset,  // synchronous active-high reset
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // States encoding
    localparam SEARCH     = 2'd0;
    localparam LOAD_DELAY = 2'd1;
    localparam COUNT      = 2'd2;
    localparam WAIT_ACK   = 2'd3;

    reg [1:0] state;

    // Shift register for pattern detection (MSB newest bit at [0])
    // We'll shift left and insert new bit at LSB: {pattern_shift[2:0], data}
    reg [3:0] pattern_shift;

    // Delay bits shift register
    reg [3:0] delay;
    reg [2:0] delay_bits_loaded; // counts 0..4 bits loaded

    // Counting counters
    reg [9:0] cycle_counter;     // counts down from 999 to 0
    reg [3:0] segment_counter;   // counts down from delay+1 to 0

    // Helper for pattern detection
    wire pattern_found = (pattern_shift == 4'b1101);

    // To detect rising edge of state changes for initialization
    reg [1:0] state_d; // previous state

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
            state_d <= 2'd0;
        end else begin
            state_d <= state; // register previous state

            case (state)
                SEARCH: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                    // Shift in new data bit at LSB (pattern_shift[3] oldest, [0] newest)
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_bits_loaded <= 3'd0;
                    delay <= 4'b0000;
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;

                    if (pattern_found) begin
                        state <= LOAD_DELAY;
                    end else begin
                        state <= SEARCH;
                    end
                end

                LOAD_DELAY: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                    // Shift in delay bits MSB first: shift left and insert data at LSB
                    delay <= {delay[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;

                    pattern_shift <= pattern_shift; // hold pattern_shift

                    if (delay_bits_loaded == 3'd3) begin
                        // After loading 4th bit, move to COUNT next cycle
                        state <= COUNT;
                    end else begin
                        state <= LOAD_DELAY;
                    end
                end

                COUNT: begin
                    pattern_shift <= pattern_shift; // hold pattern_shift
                    done <= 1'b0;
                    counting <= 1'b1;

                    // Initialize counters when entering COUNT
                    if (state_d != COUNT) begin
                        segment_counter <= delay + 1'b1;  // segments to count
                        cycle_counter <= 10'd999;         // counts cycles 0..999
                        count <= delay + 1'b1;            // output segments remaining
                    end else begin
                        if (cycle_counter == 0) begin
                            // One segment done
                            if (segment_counter > 0)
                                segment_counter <= segment_counter - 1'b1;

                            if (segment_counter > 1)
                                cycle_counter <= 10'd999;  // reload for next segment
                            else
                                cycle_counter <= 10'd0;    // last segment done or counting finished

                            // Update count output immediately after segment decrement
                            count <= (segment_counter > 0) ? (segment_counter - 1'b1) : 4'd0;
                        end else begin
                            cycle_counter <= cycle_counter - 1'b1;
                            // count output stays same during the 1000 cycles for current segment
                        end
                    end

                    // Transition to WAIT_ACK if all segments done
                    if (segment_counter == 0 && cycle_counter == 0) begin
                        state <= WAIT_ACK;
                        counting <= 1'b0;
                        done <= 1'b1;
                        count <= 4'b0000;
                    end else begin
                        state <= COUNT;
                    end
                end

                WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0000;
                    pattern_shift <= 4'b0000;
                    delay <= 4'b0000;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;

                    if (ack) begin
                        state <= SEARCH;
                    end else begin
                        state <= WAIT_ACK;
                    end
                end

                default: begin
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