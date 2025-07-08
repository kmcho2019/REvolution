module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);
    // State encoding
    localparam STATE_SEARCH = 2'd0;
    localparam STATE_LOAD_DELAY = 2'd1;
    localparam STATE_COUNT = 2'd2;
    localparam STATE_DONE = 2'd3;

    reg [1:0] state, next_state;

    // For pattern detection 1101
    reg [3:0] pattern_shift;

    // Delay value loaded (4 bits)
    reg [3:0] delay;

    // Shift counter for loading delay bits (4 bits)
    reg [2:0] load_bit_count;

    // Cycle counter for 1000 cycles
    reg [9:0] cycle_count; // 10 bits for counting up to 1000 cycles (max 999)

    // Count of how many 1000-cycle blocks left (countdown from delay to 0)
    reg [3:0] count_down;

    // Sequential state transition and registers
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_SEARCH;
            pattern_shift <= 4'd0;
            delay <= 4'd0;
            load_bit_count <= 3'd0;
            cycle_count <= 10'd0;
            count_down <= 4'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                STATE_SEARCH: begin
                    // Shift pattern_shift left, bring in new bit at LSB
                    pattern_shift <= {pattern_shift[2:0], data};
                    // Outputs are don't care here
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'dx;
                end
                STATE_LOAD_DELAY: begin
                    // Shift in the delay bits MSB first (load_bit_count counts down from 4)
                    pattern_shift <= {pattern_shift[2:0], data};
                    // delay is updated after all 4 bits shifted in
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'dx;
                end
                STATE_COUNT: begin
                    done <= 1'b0;
                    counting <= 1'b1;
                    // During counting, count_down holds the current displayed count (remaining time)
                    count <= count_down;
                end
                STATE_DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'dx;
                end
                default: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'dx;
                end
            endcase
        end
    end

    // Next state logic and internal counters
    always @(*) begin
        // Default next state
        next_state = state;

        case(state)
            STATE_SEARCH: begin
                // Wait for pattern_shift == 1101
                if (pattern_shift == 4'b1101) begin
                    next_state = STATE_LOAD_DELAY;
                end
            end
            STATE_LOAD_DELAY: begin
                // load_bit_count counts how many bits shifted in (from 0 to 3)
                if (load_bit_count == 3'd3) begin
                    // After 4 bits loaded, start counting
                    next_state = STATE_COUNT;
                end
            end
            STATE_COUNT: begin
                // When counting finishes (count_down == 0 and cycle_count == 999)
                if ((count_down == 0) && (cycle_count == 10'd999)) begin
                    next_state = STATE_DONE;
                end
            end
            STATE_DONE: begin
                // Wait for ack to be asserted to start over
                if (ack) begin
                    next_state = STATE_SEARCH;
                end
            end
        endcase
    end

    // Counters and registers update on clock
    always @(posedge clk) begin
        if (reset) begin
            load_bit_count <= 3'd0;
            delay <= 4'd0;
            cycle_count <= 10'd0;
            count_down <= 4'd0;
        end else begin
            case(state)
                STATE_SEARCH: begin
                    load_bit_count <= 3'd0;
                    delay <= 4'd0;
                    cycle_count <= 10'd0;
                    count_down <= 4'd0;
                end
                STATE_LOAD_DELAY: begin
                    // Shift in delay bits MSB first into delay
                    // We shift data into pattern_shift, so pattern_shift contains last 4 bits including delay bits
                    // We count bits shifted in from 0 to 3
                    if (load_bit_count < 3'd4) begin
                        load_bit_count <= load_bit_count + 3'd1;
                    end

                    // Update delay after all 4 bits shifted in
                    if (load_bit_count == 3'd3) begin
                        delay <= {pattern_shift[2:0], data}; // The 4 bits just shifted in, MSB first
                        count_down <= {pattern_shift[2:0], data};
                        cycle_count <= 10'd0;
                    end
                end
                STATE_COUNT: begin
                    // Count clock cycles up to 999, then decrement count_down
                    if (cycle_count < 10'd999) begin
                        cycle_count <= cycle_count + 10'd1;
                    end else begin
                        cycle_count <= 10'd0;
                        if (count_down > 0) begin
                            count_down <= count_down - 4'd1;
                        end
                    end
                end
                STATE_DONE: begin
                    load_bit_count <= 3'd0;
                    cycle_count <= 10'd0;
                    count_down <= 4'd0;
                end
            endcase
        end
    end

endmodule