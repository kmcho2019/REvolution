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

    // State encoding
    typedef enum logic [2:0] {
        SEARCH = 3'd0,
        SHIFT  = 3'd1,
        COUNT  = 3'd2,
        DONE   = 3'd3
    } state_t;

    state_t state, next_state;

    // Shift register to detect pattern 1101
    reg [3:0] pattern_shift;

    // Counter for 4 shift cycles
    reg [2:0] shift_count;

    // Pattern to detect
    localparam [3:0] START_PATTERN = 4'b1101;

    // Sequential logic: state and pattern_shift and shift_count
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'd0;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;
            // Shift in data for pattern detection only in SEARCH state or SHIFT state
            if (state == SEARCH) begin
                pattern_shift <= {pattern_shift[2:0], data};
            end else if (state == SHIFT) begin
                shift_count <= shift_count + 3'd1;
            end else begin
                shift_count <= 3'd0;
            end
        end
    end

    // Next state logic and outputs
    always @* begin
        // Default outputs
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;
        next_state = state;

        case (state)
            SEARCH: begin
                // Look for pattern 1101 on pattern_shift
                // pattern_shift updated on posedge clk above
                if (pattern_shift == START_PATTERN) begin
                    next_state = SHIFT;
                end
            end

            SHIFT: begin
                shift_ena = 1'b1;
                if (shift_count == 3'd3) begin
                    // After exactly 4 shift cycles (0..3)
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
                    next_state = SEARCH;
                end
            end

            default: next_state = SEARCH;
        endcase
    end

endmodule