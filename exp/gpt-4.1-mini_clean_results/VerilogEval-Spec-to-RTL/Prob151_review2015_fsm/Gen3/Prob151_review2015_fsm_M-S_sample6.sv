module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        SHIFT = 2'b01,
        COUNTING = 2'b10,
        DONE = 2'b11
    } state_t;

    state_t state, next_state;

    reg [3:0] pattern_reg;   // Used only in IDLE to detect pattern 1101
    reg [2:0] shift_count;   // Counts 0 to 3 for exactly 4 cycles in SHIFT

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            shift_count <= 3'd0;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Pattern detection only in IDLE state
            if (state == IDLE) begin
                pattern_reg <= {pattern_reg[2:0], data};
            end

            // Shift count increments only in SHIFT state, else reset
            if (state == SHIFT) begin
                shift_count <= shift_count + 1'b1;
            end else begin
                shift_count <= 3'd0;
            end

            // Outputs registered based on current state
            shift_ena <= (state == SHIFT);
            counting <= (state == COUNTING);
            done <= (state == DONE);
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                // Detect pattern 1101
                if (pattern_reg == 4'b1101) begin
                    next_state = SHIFT;
                end
            end
            SHIFT: begin
                // After 4 cycles, go to COUNTING
                if (shift_count == 3) begin
                    next_state = COUNTING;
                end
            end
            COUNTING: begin
                // Wait for done_counting
                if (done_counting) begin
                    next_state = DONE;
                end
            end
            DONE: begin
                // Wait for ack to go back to IDLE
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule