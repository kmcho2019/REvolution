module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // States
    typedef enum reg [1:0] {
        IDLE = 2'd0,
        SHIFT = 2'd1,
        COUNTING = 2'd2,
        DONE = 2'd3
    } state_t;
    state_t state, next_state;

    reg [3:0] pattern_shift_reg; // shift register to detect 4-bit pattern
    reg [2:0] shift_count;       // count 4 shift cycles

    // Sequential logic for state and pattern shift register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift_reg <= 4'b0000;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;
            // Shift in data bits to pattern_shift_reg only in IDLE to detect pattern
            if (state == IDLE) begin
                pattern_shift_reg <= {pattern_shift_reg[2:0], data};
            end
            // Count shifts in SHIFT state
            if (state == SHIFT) begin
                shift_count <= shift_count + 1;
            end else begin
                shift_count <= 3'd0;
            end
        end
    end

    // Next state and outputs logic
    always @(*) begin
        // Default outputs
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;
        next_state = state;

        case (state)
            IDLE: begin
                // Detect pattern 1101
                if (pattern_shift_reg == 4'b1101) begin
                    next_state = SHIFT;
                end
            end

            SHIFT: begin
                shift_ena = 1'b1;
                if (shift_count == 3'd3) begin
                    // After 4 shift cycles (0 to 3)
                    next_state = COUNTING;
                end
            end

            COUNTING: begin
                counting = 1'b1;
                if (done_counting) begin
                    next_state = DONE;
                end
            end

            DONE: begin
                done = 1'b1;
                if (ack) begin
                    next_state = IDLE;
                end
            end

            default: next_state = IDLE;
        endcase
    end

endmodule