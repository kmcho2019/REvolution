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

    // FSM state encoding
    typedef enum logic [1:0] {
        IDLE     = 2'b00,
        SHIFT    = 2'b01,
        COUNTING = 2'b10,
        DONE     = 2'b11
    } state_t;

    state_t state, next_state;

    // Shift register to detect pattern 1101 (binary 4'b1101 = 13)
    reg [3:0] pattern_shift;

    // Counter for 4 shift cycles
    reg [2:0] shift_count; // 3 bits to count up to 4

    // Pattern to detect
    localparam [3:0] PATTERN = 4'b1101;

    // Sequential logic for state, pattern shift register and shift counter
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0000;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;

            if (state == IDLE) begin
                // Shift in data to pattern_shift
                pattern_shift <= {pattern_shift[2:0], data};
            end else begin
                pattern_shift <= 4'b0000; // clear pattern shift when not in IDLE
            end

            if (state == SHIFT) begin
                shift_count <= shift_count + 1'b1;
            end else begin
                shift_count <= 3'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // default hold
        case (state)
            IDLE: begin
                // If pattern detected, go to SHIFT
                if (pattern_shift == PATTERN) begin
                    next_state = SHIFT;
                end
            end

            SHIFT: begin
                // After 4 shift cycles, move to COUNTING
                if (shift_count == 3'd3) begin
                    next_state = COUNTING;
                end
            end

            COUNTING: begin
                // Wait for done_counting to be asserted
                if (done_counting) begin
                    next_state = DONE;
                end
            end

            DONE: begin
                // Wait for ack to return to IDLE
                if (ack) begin
                    next_state = IDLE;
                end
            end

            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        shift_ena = 1'b0;
        counting  = 1'b0;
        done      = 1'b0;

        case (state)
            SHIFT:    shift_ena = 1'b1;
            COUNTING: counting  = 1'b1;
            DONE:     done      = 1'b1;
        endcase
    end

endmodule