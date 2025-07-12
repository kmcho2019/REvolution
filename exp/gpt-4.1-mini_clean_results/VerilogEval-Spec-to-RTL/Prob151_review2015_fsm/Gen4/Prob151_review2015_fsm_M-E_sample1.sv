module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

    typedef enum logic [1:0] {
        IDLE     = 2'd0, // searching for pattern 1101
        SHIFT    = 2'd1, // shifting in 4 delay bits, shift_ena asserted
        COUNTING = 2'd2, // waiting for done_counting
        DONE     = 2'd3  // done asserted, waiting for ack
    } state_t;

    state_t state, next_state;

    reg [3:0] pattern_shift;  // pattern detection shift register
    reg [1:0] shift_count;    // counts shift cycles from 0 to 3 during SHIFT state

    // Pattern detector updates only in IDLE state (continually shifts in data)
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'd0;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;

            if (state == IDLE) begin
                pattern_shift <= {pattern_shift[2:0], data};
            end

            // shift_count increments only during SHIFT state
            if (state == SHIFT) begin
                shift_count <= shift_count + 2'd1;
            end else begin
                shift_count <= 2'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                // Detect pattern 1101 to start shifting delay bits
                if (pattern_shift == 4'b1101) begin
                    next_state = SHIFT;
                end
            end
            SHIFT: begin
                // After 4 shift cycles (shift_count reaches 3), move to COUNTING
                if (shift_count == 2'd3) begin
                    next_state = COUNTING;
                end
            end
            COUNTING: begin
                if (done_counting) begin
                    next_state = DONE;
                end
            end
            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    // Output assignments (combinational)
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNTING);
    assign done      = (state == DONE);

endmodule