module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // States encoding
    typedef enum logic [1:0] {
        IDLE = 2'd0,
        READ_DELAY = 2'd1,
        COUNTING = 2'd2,
        DONE = 2'd3
    } state_t;

    state_t state, next_state;

    // Shift register for pattern detection
    reg [3:0] pattern_shift;

    // Delay register
    reg [3:0] delay;

    // Bit counter for reading delay bits
    reg [2:0] delay_bits_cnt; // counts 0 to 3

    // 10-bit cycle counter for 1000 cycles
    reg [9:0] cycle_cnt;

    // Remaining count for output count (counts from delay down to 0)
    reg [3:0] remaining;

    // Pattern constant
    localparam [3:0] START_PATTERN = 4'b1101;

    // Sequential logic: state and registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0000;
            delay <= 4'b0000;
            delay_bits_cnt <= 3'd0;
            cycle_cnt <= 10'd0;
            remaining <= 4'd0;
            count <= 4'bxxxx;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    count <= 4'bxxxx; // don't-care

                    // shift in data bit for pattern detection
                    pattern_shift <= {pattern_shift[2:0], data};
                end

                READ_DELAY: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    // shift in delay bits MSB first
                    delay <= {delay[2:0], data};
                    delay_bits_cnt <= delay_bits_cnt + 1'b1;
                end

                COUNTING: begin
                    done <= 1'b0;
                    counting <= 1'b1;

                    if (cycle_cnt == 10'd999) begin
                        cycle_cnt <= 10'd0;
                        if (remaining != 0)
                            remaining <= remaining - 1'b1;
                    end else begin
                        cycle_cnt <= cycle_cnt + 1'b1;
                    end

                    count <= remaining;
                end

                DONE: begin
                    done <= 1'b1;
                    counting <= 1'b0;
                    count <= 4'bxxxx; // don't-care
                    // wait for ack to return to IDLE, no updates to other regs
                end

                default: begin
                    // default safe values
                    done <= 1'b0;
                    counting <= 1'b0;
                    count <= 4'bxxxx;
                end
            endcase
        end
    end

    // Combinational logic: next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                // wait until pattern_shift == 1101
                if (pattern_shift == START_PATTERN)
                    next_state = READ_DELAY;
            end

            READ_DELAY: begin
                if (delay_bits_cnt == 3'd3)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // counting finishes after (delay+1)*1000 cycles
                // When remaining reaches 0 and cycle_cnt reaches 999, we finish counting
                if ((remaining == 0) && (cycle_cnt == 10'd999))
                    next_state = DONE;
            end

            DONE: begin
                // wait for ack = 1 to return to IDLE
                if (ack)
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Control signals for counters and registers on state transitions
    always @(posedge clk) begin
        if (reset) begin
            delay_bits_cnt <= 3'd0;
            cycle_cnt <= 10'd0;
            remaining <= 4'd0;
        end else begin
            case (state)
                IDLE: begin
                    delay_bits_cnt <= 3'd0;
                    cycle_cnt <= 10'd0;
                    remaining <= 4'd0;
                end

                READ_DELAY: begin
                    if (delay_bits_cnt == 3'd3) begin
                        delay_bits_cnt <= 3'd0;
                        // prepare for counting next cycle
                        cycle_cnt <= 10'd0;
                        // set remaining to delay value
                        remaining <= delay;
                    end
                end

                COUNTING: begin
                    // cycle_cnt and remaining updated in main always block
                end

                DONE: begin
                    // no changes
                end
            endcase
        end
    end

endmodule