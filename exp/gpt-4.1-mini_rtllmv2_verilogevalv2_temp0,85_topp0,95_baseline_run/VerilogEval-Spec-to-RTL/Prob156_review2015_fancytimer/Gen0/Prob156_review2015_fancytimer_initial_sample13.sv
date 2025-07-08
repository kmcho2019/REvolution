module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // States for FSM
    localparam SEARCH    = 2'd0;
    localparam LOAD_DELAY= 2'd1;
    localparam COUNTING  = 2'd2;
    localparam DONE      = 2'd3;

    reg [1:0] state, next_state;

    // Shift register for pattern detection (4 bits)
    reg [3:0] pattern_shift;

    // Shift register for loading delay (4 bits)
    reg [3:0] delay;
    reg [2:0] delay_bit_cnt; // counts 0..3 bits loaded

    // Counters for counting cycles and delay counts
    reg [9:0] cycle_cnt;  // 0..999 for 1000 cycles
    reg [3:0] delay_countdown; // current delay count during counting

    // Sequential logic: state and registers
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay <= 4'b0000;
            delay_bit_cnt <= 3'd0;
            cycle_cnt <= 10'd0;
            delay_countdown <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0000;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift in data for pattern detection
                    pattern_shift <= {pattern_shift[2:0], data};
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000; // don't care when not counting

                    // No other registers change here
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB first, so shift left
                    delay <= {delay[2:0], data};
                    delay_bit_cnt <= delay_bit_cnt + 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000; // don't care when not counting
                end

                COUNTING: begin
                    done <= 1'b0;
                    counting <= 1'b1;

                    // cycle counter increment or reset
                    if (cycle_cnt == 10'd999) begin
                        cycle_cnt <= 10'd0;

                        // Decrement delay_countdown if > 0
                        if (delay_countdown != 4'd0)
                            delay_countdown <= delay_countdown - 1'b1;
                        // else if zero, done counting will be signaled next state
                    end else begin
                        cycle_cnt <= cycle_cnt + 1'b1;
                    end

                    count <= delay_countdown;
                end

                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0000; // don't care when not counting

                    // Wait for ack, no register changes except state handled outside
                end

                default: begin
                    // Should never happen
                    state <= SEARCH;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;

        case(state)
            SEARCH: begin
                // When pattern_shift is 1101, move to LOAD_DELAY
                // pattern_shift is MSB oldest, LSB newest bit, so check exact bits
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                // After 4 bits loaded, move to COUNTING
                if (delay_bit_cnt == 3'd4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // When delay_countdown reached zero and cycle_cnt hit 999 (completed last 1000 cycles)
                if (delay_countdown == 4'd0 && cycle_cnt == 10'd999)
                    next_state = DONE;
            end

            DONE: begin
                // Wait for ack == 1 to return to SEARCH
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

    // Initialize delay_bit_cnt and delay_countdown on transitions
    always @(posedge clk) begin
        if (reset) begin
            delay_bit_cnt <= 3'd0;
            delay_countdown <= 4'd0;
            cycle_cnt <= 10'd0;
        end else begin
            case (state)
                SEARCH: begin
                    delay_bit_cnt <= 3'd0;
                    cycle_cnt <= 10'd0;
                end
                LOAD_DELAY: begin
                    // delay_bit_cnt incremented in main always block above
                end
                COUNTING: begin
                    // When entering COUNTING state, load delay_countdown and clear cycle counter
                    if (state != COUNTING && next_state == COUNTING) begin
                        delay_countdown <= delay;
                        cycle_cnt <= 10'd0;
                    end
                end
                DONE: begin
                    // no change here
                end
            endcase
        end
    end

endmodule