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

    // State encoding (one-hot-like for simplicity)
    typedef enum logic [1:0] {
        PATTERN = 2'd0, // searching for 1101 pattern via shift register
        SHIFT   = 2'd1, // shifting delay bits (4 cycles)
        COUNT   = 2'd2, // counting delay
        DONE    = 2'd3  // done, waiting for ack
    } state_t;

    state_t state, next_state;

    // 4-bit shift register to hold last 4 bits of serial input
    reg [3:0] pattern_shift;

    // 2-bit counter for SHIFT cycles (0 to 3)
    reg [1:0] shift_count;

    // Update pattern shift register synchronously, and state, counters
    always @(posedge clk) begin
        if (reset) begin
            state <= PATTERN;
            shift_count <= 2'd0;
            pattern_shift <= 4'b0000;
        end else begin
            pattern_shift <= {pattern_shift[2:0], data};
            state <= next_state;
            if (state == SHIFT)
                shift_count <= shift_count + 2'd1;
            else
                shift_count <= 2'd0;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            PATTERN: begin
                // Detect pattern 1101 in last 4 bits
                if (pattern_shift == 4'b1101)
                    next_state = SHIFT;
                else
                    next_state = PATTERN;
            end
            SHIFT: begin
                if (shift_count == 2'd3)
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end
            COUNT: begin
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end
            DONE: begin
                if (ack)
                    next_state = PATTERN;
                else
                    next_state = DONE;
            end
            default: next_state = PATTERN;
        endcase
    end

    // Outputs combinationally from state
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule