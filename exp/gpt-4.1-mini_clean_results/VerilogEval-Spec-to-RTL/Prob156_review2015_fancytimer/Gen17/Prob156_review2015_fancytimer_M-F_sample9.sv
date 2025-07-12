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
    localparam SEARCH     = 2'd0;
    localparam LOAD_DELAY = 2'd1;
    localparam COUNT      = 2'd2;
    localparam WAIT_ACK   = 2'd3;

    reg [1:0] state, next_state;

    // Shift register for pattern detection (newest bit at MSB = bit 3)
    reg [3:0] pattern_shift;

    // Delay register loaded MSB-first (newest bit at MSB)
    reg [3:0] delay;
    reg [2:0] delay_bits_loaded; // counts bits loaded (0..4)

    // Counters for counting timing
    reg [9:0] cycle_counter;    // counts down 999..0
    reg [3:0] segment_counter;  // counts down (delay+1)..0, each represents 1000 cycle segments

    // Pattern found combinational
    wire pattern_found = (pattern_shift == 4'b1101);

    // Next state combinational logic
    always @(*) begin
        case(state)
            SEARCH: next_state = pattern_found ? LOAD_DELAY : SEARCH;
            LOAD_DELAY: next_state = (delay_bits_loaded == 3'd4) ? COUNT : LOAD_DELAY;
            COUNT: next_state = ((segment_counter == 4'd0) && (cycle_counter == 10'd0)) ? WAIT_ACK : COUNT;
            WAIT_ACK: next_state = ack ? SEARCH : WAIT_ACK;
            default: next_state = SEARCH;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            // Initialize all registers
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
                    // Shift in new data at MSB (newest bit at bit 3), shift right by 1 bit
                    pattern_shift <= {pattern_shift[2:0], data}; // original code shifted in at LSB; change to newest bit at MSB as per problem

                    // Correction for MSB-first pattern detection:
                    // The problem states pattern is MSB-first: newest bit at MSB (bit3).
                    // So we shift pattern_shift right by one, new bit goes into MSB:
                    // So the correct shift is pattern_shift <= {data, pattern_shift[3:1]};
                    // Fixing now:

                    // So overwrite with correct pattern shift:
                    // done below after case block to avoid double assignment

                    // Clear other signals
                    delay <= 4'b0000;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB-first: newest bit at MSB = bit 3
                    // So delay shifts right 1 bit, new bit at MSB:
                    // delay <= {data, delay[3:1]};
                    // But shifting delay right? To load MSB first, shift right inserting new bit at MSB
                    delay <= {delay[2:0], data}; 
                    // Wait, this inserts new bit at LSB, opposite of needed behavior.

                    // To load MSB-first as problem states (bit 3 first), we want new bit at MSB.
                    // So shift right (>>1), insert data at MSB:
                    // delay <= {data, delay[3:1]};
                    // Use that instead.

                    delay <= {delay[3:1], data}; // WRONG, this puts new bit at LSB

                    // Correct way: shift left one, insert new bit at LSB = {delay[2:0], data} (new bit at LSB)
                    // But problem says MSB-first, so first bit received is MSB.
                    // So we want to shift delay right by one bit and insert data at MSB:
                    delay <= {data, delay[3:1]};

                    delay_bits_loaded <= delay_bits_loaded + 1'b1;

                    // pattern_shift unchanged during LOAD_DELAY
                    pattern_shift <= pattern_shift;

                    counting <= 1'b0;
                    done <= 1'b0;
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                    count <= 4'b0000;
                end

                COUNT: begin
                    // Hold pattern_shift stable
                    pattern_shift <= pattern_shift;
                    delay_bits_loaded <= delay_bits_loaded;

                    counting <= 1'b1;
                    done <= 1'b0;

                    if (cycle_counter == 10'd0) begin
                        // Starting new 1000 cycle segment or segment just finished
                        if (segment_counter == 4'd0) begin
                            // All segments counted, counting done
                            counting <= 1'b0;
                            count <= 4'b0000;
                            cycle_counter <= 10'd0;
                            segment_counter <= 4'd0;
                        end else begin
                            // Start next 1000 cycle segment
                            cycle_counter <= 10'd999;
                            segment_counter <= segment_counter - 1'b1;
                            count <= segment_counter - 1'b1; // count shows remaining segments after decrement
                        end
                    end else begin
                        cycle_counter <= cycle_counter - 1'b1;
                        // count holds steady during a segment
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

            // Update pattern_shift MSB-first shift (newest bit at bit 3) during SEARCH state only,
            // Because in LOAD_DELAY and later, pattern_shift stays constant.

            if (state == SEARCH) begin
                pattern_shift <= {data, pattern_shift[3:1]};
            end

            // On entering COUNT state (state not COUNT but next_state == COUNT), initialize counters
            if ((state != COUNT) && (next_state == COUNT)) begin
                segment_counter <= delay + 1'b1; // segments = delay+1
                cycle_counter <= 10'd999;         // each segment 1000 cycles counted from 999 down to 0
                count <= delay + 1'b1 - 1'b1;     // output count initialized to delay (remaining segments - 1)
                counting <= 1'b1;
                done <= 1'b0;
            end

            // Clear done flag when not in WAIT_ACK
            if (state != WAIT_ACK)
                done <= 1'b0;
        end
    end

endmodule