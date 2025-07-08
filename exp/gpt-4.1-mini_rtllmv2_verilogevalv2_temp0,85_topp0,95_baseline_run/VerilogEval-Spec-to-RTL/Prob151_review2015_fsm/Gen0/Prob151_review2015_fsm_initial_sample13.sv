module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    typedef enum logic [2:0] {
        IDLE = 3'd0,
        SHIFT = 3'd1,
        COUNT = 3'd2,
        DONE = 3'd3
    } state_t;

    state_t state, next_state;

    reg [3:0] pattern_shift; // to detect 1101 pattern
    reg [2:0] shift_count;   // counts 4 shift cycles

    // Pattern to detect: 1101 (binary)
    localparam [3:0] START_PATTERN = 4'b1101;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0000;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;

            // Update pattern_shift only in IDLE or SHIFT state for pattern detection or shift counting
            if (state == IDLE) begin
                // Shift in new data bit for pattern detection
                pattern_shift <= {pattern_shift[2:0], data};
            end else if (state == SHIFT) begin
                // Increment shift_count, shift pattern_shift (optional, mainly to count shifts)
                shift_count <= shift_count + 1;
            end else begin
                // Clear shift_count and pattern_shift outside IDLE and SHIFT for safety
                shift_count <= 3'd0;
                pattern_shift <= 4'b0000;
            end
        end
    end

    // Next state logic and outputs
    always @(*) begin
        // Default outputs
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;
        next_state = state;

        case(state)
            IDLE: begin
                // Look for pattern 1101
                if (pattern_shift == START_PATTERN) begin
                    next_state = SHIFT;
                    // shift_count and pattern_shift updated on clock edge
                end
            end
            SHIFT: begin
                shift_ena = 1'b1;
                if (shift_count == 3'd3) begin // 4 cycles counted from 0 to 3
                    next_state = COUNT;
                end
            end
            COUNT: begin
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