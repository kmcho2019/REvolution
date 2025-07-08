module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // State encoding
    localparam STATE_SEARCH     = 2'd0;
    localparam STATE_SHIFT_DELAY= 2'd1;
    localparam STATE_COUNTING   = 2'd2;
    localparam STATE_DONE       = 2'd3;

    reg [1:0] state, next_state;

    // Shift register for pattern detection
    reg [3:0] shift_pattern;

    // Shift register for delay bits
    reg [3:0] delay_reg;
    reg [2:0] delay_bit_cnt; // counts from 4 down to 0, for shifting in delay bits

    // Counters for counting cycles
    reg [9:0] cycle_cnt;    // counts 0 to 999 cycles
    reg [3:0] delay_count;  // counts down delay from delay_reg to 0

    // Pattern to detect: 1101 binary = 4'b1101
    wire pattern_found = (shift_pattern == 4'b1101);

    // Sequential logic: state and registers
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_SEARCH;
            shift_pattern <= 4'b0000;
            delay_reg <= 4'b0000;
            delay_bit_cnt <= 3'd0;
            cycle_cnt <= 10'd0;
            delay_count <= 4'd0;
            count <= 4'bxxxx; // don't care
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                STATE_SEARCH: begin
                    // shift in data bit for pattern detection
                    shift_pattern <= {shift_pattern[2:0], data};
                    // outputs
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx;
                end

                STATE_SHIFT_DELAY: begin
                    // shift in next 4 bits MSB first
                    // delay_bit_cnt counts from 4 down to 1
                    if (delay_bit_cnt > 0) begin
                        delay_reg <= {delay_reg[2:0], data};
                        delay_bit_cnt <= delay_bit_cnt - 1;
                    end
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx;
                end

                STATE_COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    count <= delay_count;

                    if (cycle_cnt == 10'd999) begin
                        cycle_cnt <= 10'd0;
                        if (delay_count > 0)
                            delay_count <= delay_count - 1;
                        // else delay_count == 0, will move to DONE state in next_state logic
                    end else begin
                        cycle_cnt <= cycle_cnt + 1;
                    end
                end

                STATE_DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'bxxxx;
                end

                default: begin
                    // default to SEARCH on invalid state
                    state <= STATE_SEARCH;
                    shift_pattern <= 4'b0000;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx;
                end
            endcase
        end
    end

    // Next state logic and control signals
    always @(*) begin
        next_state = state;
        case (state)
            STATE_SEARCH: begin
                if (pattern_found)
                    next_state = STATE_SHIFT_DELAY;
            end

            STATE_SHIFT_DELAY: begin
                if (delay_bit_cnt == 0)
                    next_state = STATE_COUNTING;
            end

            STATE_COUNTING: begin
                // When delay_count=0 and cycle_cnt==999, counting is done
                if ((delay_count == 0) && (cycle_cnt == 10'd999))
                    next_state = STATE_DONE;
            end

            STATE_DONE: begin
                if (ack)
                    next_state = STATE_SEARCH;
            end

            default: next_state = STATE_SEARCH;
        endcase
    end

    // Control delay_bit_cnt and delay_count initialization
    always @(posedge clk) begin
        if (reset) begin
            delay_bit_cnt <= 3'd4; // initialize to 4 to shift in 4 bits
            delay_count <= 4'd0;
            cycle_cnt <= 10'd0;
        end else begin
            if (state == STATE_SEARCH) begin
                delay_bit_cnt <= 3'd4;
                cycle_cnt <= 10'd0;
                delay_count <= 4'd0;
            end else if (state == STATE_SHIFT_DELAY) begin
                // delay_bit_cnt decrement handled in main always block above
                // do nothing here
            end else if (state == STATE_COUNTING && state != next_state) begin
                // On entering COUNTING state, initialize delay_count and cycle_cnt
                delay_count <= delay_reg;
                cycle_cnt <= 10'd0;
            end else if (state == STATE_DONE) begin
                // no change to delay_count or cycle_cnt
            end
        end
    end

endmodule