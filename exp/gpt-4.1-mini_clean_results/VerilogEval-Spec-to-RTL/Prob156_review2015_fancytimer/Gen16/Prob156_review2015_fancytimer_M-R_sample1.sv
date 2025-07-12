module TopModule (
    input  wire       clk,
    input  wire       reset,  // synchronous active-high reset
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // State encoding using localparams (4 states)
    localparam SEARCH     = 2'd0;
    localparam LOAD_DELAY = 2'd1;
    localparam COUNT      = 2'd2;
    localparam WAIT_ACK   = 2'd3;

    reg [1:0] state, next_state;

    // Shift register for detecting pattern 1101 (MSB-first)
    reg [3:0] pattern_shift;

    // Delay register and bit counter for loading 4 delay bits
    reg [3:0] delay;
    reg [2:0] delay_bits_loaded; // counts 0..4

    // Counters for counting phase
    reg [9:0] cycle_counter;    // counts 0..999 cycles per segment
    reg [3:0] segment_counter;  // counts delay+1 down to 0 segments

    // Pattern detection wire
    wire pattern_found = (pattern_shift == 4'b1101);

    // Next state logic combinational
    always @(*) begin
        case (state)
            SEARCH: begin
                if (pattern_found)
                    next_state = LOAD_DELAY;
                else
                    next_state = SEARCH;
            end
            LOAD_DELAY: begin
                if (delay_bits_loaded == 3'd4)
                    next_state = COUNT;
                else
                    next_state = LOAD_DELAY;
            end
            COUNT: begin
                if ((segment_counter == 0) && (cycle_counter == 0))
                    next_state = WAIT_ACK;
                else
                    next_state = COUNT;
            end
            WAIT_ACK: begin
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = WAIT_ACK;
            end
            default: next_state = SEARCH;
        endcase
    end

    // Sequential logic: state and registers update
    always @(posedge clk) begin
        if (reset) begin
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

            case (state)
                SEARCH: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    count <= 4'b0000;
                    delay <= 4'b0000;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;

                    // Shift in new data bit MSB-first into pattern_shift
                    // Shift left and insert new bit at LSB, to track last 4 bits received on data line
                    pattern_shift <= {pattern_shift[2:0], data};
                end

                LOAD_DELAY: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    count <= 4'b0000;

                    // Keep pattern_shift stable (do not update)
                    // Shift delay register left and insert data at LSB (MSB-first shift in)
                    delay <= {delay[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;
                end

                COUNT: begin
                    done <= 1'b0;
                    counting <= 1'b1;

                    // Hold pattern_shift stable
                    // Hold delay and delay_bits_loaded stable

                    // Initialize counters on entering COUNT state
                    // Detect rising edge of COUNT state by comparing previous state
                    if (state != COUNT && next_state == COUNT) begin
                        segment_counter <= delay + 1'b1; // number of 1000-cycle segments
                        cycle_counter <= 10'd999;       // counts down 999..0 = 1000 cycles total
                    end else begin
                        // Normal counting logic
                        if (cycle_counter == 0) begin
                            // Finished one 1000-cycle segment, decrement segment counter if not zero
                            if (segment_counter != 0) begin
                                segment_counter <= segment_counter - 1'b1;
                                cycle_counter <= 10'd999; // reload cycle counter
                            end
                        end else begin
                            // Count down cycle counter
                            cycle_counter <= cycle_counter - 1'b1;
                        end
                    end

                    // count output logic:
                    // count shows the current remaining segment count
                    // While cycle_counter > 0, count = segment_counter - 1 (since current segment not finished)
                    // When cycle_counter == 0, count = segment_counter
                    if (cycle_counter == 0)
                        count <= segment_counter;
                    else if (segment_counter != 0)
                        count <= segment_counter - 1'b1;
                    else
                        count <= 4'd0; // no segments left
                end

                WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0000;

                    // Hold pattern_shift, delay, counters stable until ack received and reset
                end

                default: begin
                    // Defensive default assignments
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                    pattern_shift <= 4'b0000;
                    delay <= 4'b0000;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                end
            endcase
        end
    end

endmodule