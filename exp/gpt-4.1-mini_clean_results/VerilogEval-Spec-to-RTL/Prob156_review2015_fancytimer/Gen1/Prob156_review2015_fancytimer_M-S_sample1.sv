module TopModule (
    input clk,
    input reset,     // synchronous active high
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // States
    localparam SEARCH     = 2'd0;
    localparam LOAD_DELAY = 2'd1;
    localparam COUNTING   = 2'd2;
    localparam DONE       = 2'd3;

    reg [1:0] state, next_state;

    // Shift register for pattern detection (last 4 bits)
    reg [3:0] pattern_shift;

    // Delay register
    reg [3:0] delay;

    // Counter for how many delay bits shifted in LOAD_DELAY (0 to 4)
    reg [2:0] delay_bit_count;

    // 10-bit counter counts 0..999 cycles per delay step
    reg [9:0] cycle_1000;

    // Delay countdown counter (counts delay down to 0)
    reg [3:0] delay_countdown;

    // Pattern detection (1101)
    wire pattern_found = (pattern_shift == 4'b1101);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay <= 4'b0000;
            delay_bit_count <= 3'd0;
            cycle_1000 <= 10'd0;
            delay_countdown <= 4'd0;
            count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift in data to pattern_shift for detection
                    pattern_shift <= {pattern_shift[2:0], data};
                    done <= 1'b0;
                    counting <= 1'b0;
                    count <= 4'bx; // don't-care when not counting
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB first: shift left and insert new data bit LSB
                    delay <= {delay[2:0], data};
                    delay_bit_count <= delay_bit_count + 1'b1;
                    done <= 1'b0;
                    counting <= 1'b0;
                    count <= 4'bx; // don't-care
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Increment 1000-cycle counter
                    if (cycle_1000 == 10'd999) begin
                        cycle_1000 <= 10'd0;
                        // After 1000 cycles, decrement delay_countdown if > 0
                        if (delay_countdown != 0)
                            delay_countdown <= delay_countdown - 1'b1;
                        // else remain 0
                    end else begin
                        cycle_1000 <= cycle_1000 + 1'b1;
                    end

                    count <= delay_countdown; // output current delay step
                end

                DONE: begin
                    done <= 1'b1;
                    counting <= 1'b0;
                    count <= 4'bx; // don't-care
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                if (pattern_found)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                if (delay_bit_count == 3'd4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // Transition to DONE after counting (delay+1)*1000 cycles
                // Since delay_countdown counts down from delay to 0,
                // when delay_countdown == 0 and cycle_1000 == 999, counting done
                if ((delay_countdown == 0) && (cycle_1000 == 10'd999))
                    next_state = DONE;
            end

            DONE: begin
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

    // Delay bit count reset logic on reset and entering LOAD_DELAY
    always @(posedge clk) begin
        if (reset) begin
            delay_bit_count <= 3'd0;
        end else if (state == SEARCH && next_state == LOAD_DELAY) begin
            delay_bit_count <= 3'd0;
            delay <= 4'b0000;
        end
    end

    // Initialize delay_countdown and cycle_1000 when entering COUNTING
    reg state_counting_prev;
    always @(posedge clk) begin
        if (reset) begin
            state_counting_prev <= 1'b0;
            delay_countdown <= 4'd0;
            cycle_1000 <= 10'd0;
        end else begin
            state_counting_prev <= state == COUNTING;
            if (!state_counting_prev && (state == COUNTING)) begin
                // load countdown with delay
                delay_countdown <= delay;
                cycle_1000 <= 10'd0;
            end
        end
    end

endmodule