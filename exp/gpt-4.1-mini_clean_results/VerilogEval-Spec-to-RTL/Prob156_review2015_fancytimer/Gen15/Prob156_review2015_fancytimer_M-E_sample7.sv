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
    typedef enum logic [1:0] {
        SEARCH     = 2'd0,
        LOAD_DELAY = 2'd1,
        COUNT      = 2'd2,
        WAIT_ACK   = 2'd3
    } state_t;

    state_t state, next_state;

    // Shift register for detecting pattern 1101 (MSB-first)
    reg [3:0] pattern_shift;

    // Delay register and bit counter for loading 4 delay bits
    reg [3:0] delay;
    reg [2:0] delay_bits_loaded; // counts 0..4

    // Counters for counting phase
    reg [9:0] cycle_counter;    // counts 0..999 cycles per segment
    reg [3:0] segment_counter;  // counts delay+1 down to 0 segments

    // Pattern detection: shift left and insert new bit at MSB (MSB-first)
    // pattern_shift[3] is newest bit, pattern_shift[0] is oldest of last 4
    // pattern to detect is 1101: MSB pattern_shift[3]=1, pattern_shift[2]=1, pattern_shift[1]=0, pattern_shift[0]=1
    // This matches direct comparison to 4'b1101
    wire pattern_found = (pattern_shift == 4'b1101);

    // Update pattern shift register
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift <= 4'b0000;
        end else if (state == SEARCH) begin
            // Shift left, insert new data at MSB
            pattern_shift <= {pattern_shift[2:0], data};
        end
        // Hold pattern_shift in other states
    end

    // FSM next state logic
    always @(*) begin
        case (state)
            SEARCH:     next_state = pattern_found ? LOAD_DELAY : SEARCH;
            LOAD_DELAY: next_state = (delay_bits_loaded == 3'd4) ? COUNT : LOAD_DELAY;
            COUNT:      next_state = (segment_counter == 0 && cycle_counter == 0) ? WAIT_ACK : COUNT;
            WAIT_ACK:   next_state = ack ? SEARCH : WAIT_ACK;
            default:    next_state = SEARCH;
        endcase
    end

    // FSM state register
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
        end else begin
            state <= next_state;
        end
    end

    // Delay loading and counters
    always @(posedge clk) begin
        if (reset) begin
            delay <= 4'b0000;
            delay_bits_loaded <= 3'd0;
            cycle_counter <= 10'd0;
            segment_counter <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0000;
        end else begin
            case (state)
                SEARCH: begin
                    // Reset delay loading registers
                    delay <= 4'b0000;
                    delay_bits_loaded <= 3'd0;

                    // Clear counting signals
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;

                    // No counters running
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                end

                LOAD_DELAY: begin
                    done <= 1'b0;
                    counting <= 1'b0;

                    // Shift delay register left, insert data at LSB (MSB-first shift in)
                    // On first bit shifted, delay[3] is filled first, then down to delay[0]
                    delay <= {delay[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;

                    // No counting yet
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                    count <= 4'b0000;
                end

                COUNT: begin
                    done <= 1'b0;
                    counting <= 1'b1;

                    // On entry to COUNT state, initialize counters once
                    if (next_state != COUNT) begin
                        // Just before leaving COUNT state
                        // No action needed here
                    end

                    if (cycle_counter == 0 && segment_counter == 0) begin
                        // Counting done, but state transition will move to WAIT_ACK
                        counting <= 1'b0;
                    end else begin
                        if (cycle_counter == 0) begin
                            // Start new 1000-cycle segment
                            cycle_counter <= 10'd999;
                            // Decrement segment counter if not first segment start
                            if (segment_counter != delay + 1) begin
                                segment_counter <= segment_counter - 1'b1;
                            end
                        end else begin
                            // Countdown cycle counter
                            cycle_counter <= cycle_counter - 1'b1;
                        end
                    end

                    // On entry to COUNT state (detected by state transition), initialize counters
                    if (state != COUNT && next_state == COUNT) begin
                        // (delay+1) segments, each 1000 cycles
                        segment_counter <= delay + 1'b1;
                        cycle_counter <= 10'd999; // start counting first 1000 cycles (0..999)
                    end

                    // Output count is current segments left minus one if cycle_counter is not zero
                    // Actually display remaining segment counts properly:
                    // count output = segment_counter - 1 if cycle_counter != 0 else segment_counter
                    // To reflect the remaining segment during current 1000 cycles.
                    if (cycle_counter == 0)
                        count <= segment_counter;
                    else
                        count <= (segment_counter > 0) ? segment_counter - 1'b1 : 4'd0;
                end

                WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0000;

                    // Reset counters, pattern shift and delay will be reset in SEARCH state after ack
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                    delay_bits_loaded <= 3'd0;
                    delay <= delay;
                end

                default: begin
                    // Should not occur - reset all signals to safe state
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                    delay_bits_loaded <= 3'd0;
                    delay <= 4'b0000;
                end
            endcase
        end
    end

endmodule