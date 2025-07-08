module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output reg  shift_ena,
    output reg  counting,
    output reg  done
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE = 3'd0,
        SHIFT = 3'd1,
        COUNTING = 3'd2,
        DONE = 3'd3
    } state_t;

    state_t state, next_state;

    // Shift register for pattern detection
    reg [3:0] pattern_shift;

    // Counter for shift cycles (4 cycles)
    reg [2:0] shift_count;

    // Pattern to detect is 1101 (binary)
    localparam [3:0] START_PATTERN = 4'b1101;

    // Sequential logic: state register and pattern shift register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0000;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;

            // Shift in the incoming data bit during IDLE and SHIFT states
            if (state == IDLE) begin
                pattern_shift <= {pattern_shift[2:0], data};
            end else if (state == SHIFT) begin
                pattern_shift <= {pattern_shift[2:0], data};
            end

            // Count shift cycles in SHIFT state
            if (state == SHIFT) begin
                shift_count <= shift_count + 3'd1;
            end else begin
                shift_count <= 3'd0;
            end
        end
    end

    // Next state and output logic
    always @(*) begin
        // Default outputs
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;

        next_state = state;

        case (state)
            IDLE: begin
                // Wait for pattern 1101
                if (pattern_shift == START_PATTERN) begin
                    next_state = SHIFT;
                    // shift_count reset in sequential block
                end
            end

            SHIFT: begin
                shift_ena = 1'b1;
                if (shift_count == 3'd3) begin
                    // After 4 cycles (0 to 3)
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