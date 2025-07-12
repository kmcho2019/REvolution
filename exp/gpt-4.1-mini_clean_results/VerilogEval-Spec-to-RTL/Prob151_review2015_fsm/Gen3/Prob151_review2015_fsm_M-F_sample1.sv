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

    // State encoding
    localparam IDLE     = 2'd0;
    localparam SHIFT    = 2'd1;
    localparam COUNTING = 2'd2;
    localparam DONE     = 2'd3;

    reg [1:0] state, next_state;

    // Pattern detection 4-bit shift register (shifts every clock)
    reg [3:0] pattern_shift;

    // Raw combinational pattern detection (pattern "1101")
    wire pattern_matched_raw = (pattern_shift == 4'b1101);

    // Registered pattern matched signal delayed by one cycle to align FSM transition
    reg pattern_matched_d;

    // SHIFT state counter (counts 0..3)
    reg [1:0] shift_count;

    // Pattern shift register update every clock, synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift <= 4'b0000;
        end else begin
            pattern_shift <= {pattern_shift[2:0], data};
        end
    end

    // Register pattern_matched_d to hold pattern detection for FSM use
    always @(posedge clk) begin
        if (reset) begin
            pattern_matched_d <= 1'b0;
        end else if (state == IDLE) begin
            // Latch pattern detection flag only in IDLE state
            // This ensures pattern_matched_d is asserted for one cycle,
            // allowing FSM to react to stable detection on next clock
            pattern_matched_d <= pattern_matched_raw;
        end else begin
            // Clear pattern matched once leaving IDLE (start SHIFT)
            pattern_matched_d <= 1'b0;
        end
    end

    // FSM sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state       <= IDLE;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;

            if (state == SHIFT) begin
                // Increment shift counter during SHIFT
                shift_count <= shift_count + 1'b1;
            end else begin
                // Reset shift counter otherwise
                shift_count <= 2'd0;
            end
        end
    end

    // FSM combinational logic for next state and outputs
    always @(*) begin
        // Defaults
        next_state = state;
        shift_ena  = 1'b0;
        counting   = 1'b0;
        done       = 1'b0;

        case(state)
            IDLE: begin
                // Wait for registered pattern detection to start shifting
                if (pattern_matched_d) begin
                    next_state = SHIFT;
                end
            end

            SHIFT: begin
                // Enable shifting for exactly 4 cycles: counts 0..3
                shift_ena = 1'b1;
                if (shift_count == 2'd3) begin
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