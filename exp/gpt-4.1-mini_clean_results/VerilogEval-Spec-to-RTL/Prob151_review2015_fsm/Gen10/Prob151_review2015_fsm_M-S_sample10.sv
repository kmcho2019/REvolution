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

    // Simple FSM states
    typedef enum logic [1:0] {
        IDLE  = 2'd0, // searching pattern
        SHIFT = 2'd1, // shifting 4 bits
        WAIT  = 2'd2  // waiting for counting done and ack
    } state_t;

    state_t state, next_state;

    reg [3:0] pattern_shift;   // shift register for last 4 bits
    reg [2:0] shift_count;     // counts 4 shift cycles (0 to 3)

    // Sequential logic: state, pattern_shift, shift_count updates
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'd0;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;
            if (state == IDLE) begin
                // Shift in data to detect pattern 1101
                pattern_shift <= {pattern_shift[2:0], data};
                shift_count <= 3'd0;
            end else if (state == SHIFT) begin
                // Count 4 shift cycles during SHIFT
                shift_count <= shift_count + 3'd1;
            end else begin
                // Clear counter when not in SHIFT
                shift_count <= 3'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                // Check if pattern 1101 detected in last 4 bits
                // binary 1101 = 4'b1101 = 13 decimal
                if (pattern_shift == 4'b1101)
                    next_state = SHIFT;
            end
            SHIFT: begin
                // After 4 shift cycles, go to WAIT
                if (shift_count == 3'd3)
                    next_state = WAIT;
            end
            WAIT: begin
                // Wait for done_counting to assert
                if (done_counting)
                    next_state = (ack) ? IDLE : WAIT;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic (Moore FSM style)
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == WAIT) && !done_counting;
        done      = (state == WAIT) && done_counting;
    end

endmodule