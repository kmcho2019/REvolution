module TopModule (
    input  wire       clk,
    input  wire       reset,  // synchronous active-high reset
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // FSM States
    typedef enum logic [1:0] {
        SEARCH     = 2'd0,
        LOAD_DELAY = 2'd1,
        COUNT      = 2'd2,
        WAIT_ACK   = 2'd3
    } state_t;

    state_t state, next_state;

    reg [3:0] pattern_shift;      // pattern detection shift reg (MSB newest bit)
    reg [3:0] delay;              // 4-bit delay register MSB-first
    reg [2:0] load_count;         // counts number of bits loaded for delay (0 to 4)

    reg [3:0] segment_counter;    // counts delay+1 down to 0
    reg [9:0] cycle_counter;      // counts 999 down to 0 (1000 cycles per segment)

    wire pattern_detected = (pattern_shift == 4'b1101);

    // Next state logic combinational
    always @(*) begin
        case (state)
            SEARCH:     next_state = pattern_detected ? LOAD_DELAY : SEARCH;
            LOAD_DELAY: next_state = (load_count == 3'd4) ? COUNT : LOAD_DELAY;
            COUNT:      next_state = (segment_counter == 4'd0 && cycle_counter == 10'd0) ? WAIT_ACK : COUNT;
            WAIT_ACK:   next_state = ack ? SEARCH : WAIT_ACK;
            default:    next_state = SEARCH;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay <= 4'b0000;
            load_count <= 3'd0;
            segment_counter <= 4'd0;
            cycle_counter <= 10'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'bxxxx; // don't-care when not counting
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift in data MSB-first at pattern_shift (new bit at MSB)
                    pattern_shift <= {data, pattern_shift[3:1]};

                    // Clear delay loading
                    delay <= 4'b0000;
                    load_count <= 3'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    segment_counter <= 4'd0;
                    cycle_counter <= 10'd0;
                    count <= 4'bxxxx; // don't care
                end

                LOAD_DELAY: begin
                    // pattern_shift holds at detected pattern (no shift)
                    pattern_shift <= pattern_shift;

                    // Shift in delay bits MSB-first: shift right by one, new data at MSB
                    delay <= {data, delay[3:1]};
                    load_count <= load_count + 1'b1;

                    counting <= 1'b0;
                    done <= 1'b0;

                    segment_counter <= 4'd0;
                    cycle_counter <= 10'd0;
                    count <= 4'bxxxx;
                end

                COUNT: begin
                    // Freeze pattern_shift and load_count during counting
                    pattern_shift <= pattern_shift;
                    load_count <= load_count;

                    counting <= 1'b1;
                    done <= 1'b0;

                    // Initialize counters on entering COUNT state
                    if (state != COUNT) begin
                        segment_counter <= delay + 1'b1; // segments to count
                        cycle_counter <= 10'd999;         // 1000 cycles per segment (0..999)
                        count <= delay;                   // count shows current segment remaining
                    end else begin
                        if (cycle_counter == 0) begin
                            if (segment_counter == 0) begin
                                // Counting finished
                                counting <= 1'b0;
                                count <= 4'b0000;
                            end else begin
                                // Next segment
                                segment_counter <= segment_counter - 1'b1;
                                cycle_counter <= 10'd999;
                                count <= segment_counter - 1'b1; // update count for next segment
                            end
                        end else begin
                            cycle_counter <= cycle_counter - 1'b1;
                            // count stays stable during segment
                        end
                    end
                end

                WAIT_ACK: begin
                    // Hold outputs while waiting for ack
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'bxxxx; // don't care

                    // Freeze pattern_shift, delay, load_count, counters
                    pattern_shift <= pattern_shift;
                    delay <= delay;
                    load_count <= load_count;
                    segment_counter <= segment_counter;
                    cycle_counter <= cycle_counter;
                end

                default: begin
                    // Should not happen, safe defaults
                    state <= SEARCH;
                    pattern_shift <= 4'b0000;
                    delay <= 4'b0000;
                    load_count <= 3'd0;
                    segment_counter <= 4'd0;
                    cycle_counter <= 10'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                end
            endcase
        end
    end

endmodule