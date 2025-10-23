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

    typedef enum logic [2:0] {
        SEARCH   = 3'd0, // Looking for pattern 1101
        SHIFT0   = 3'd1, // Shift cycle 1 (shift_ena asserted)
        SHIFT1   = 3'd2, // Shift cycle 2
        SHIFT2   = 3'd3, // Shift cycle 3
        SHIFT3   = 3'd4, // Shift cycle 4
        COUNTING = 3'd5, // Waiting for counting to finish
        DONE     = 3'd6  // Timer done, waiting for ack
    } state_t;

    state_t state, next_state;

    reg [3:0] pattern_shift; // For detecting 1101 and loading delay bits

    // Sequential logic: state and pattern shift register
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'd0;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Update pattern_shift only in SEARCH and SHIFT states
            if (state == SEARCH || (state >= SHIFT0 && state <= SHIFT3)) begin
                pattern_shift <= {pattern_shift[2:0], data};
            end
            // Else pattern_shift remains unchanged

            // Outputs assigned based on current state (Moore outputs)
            shift_ena <= (state >= SHIFT0 && state <= SHIFT3);
            counting <= (state == COUNTING);
            done <= (state == DONE);
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                // Detect pattern 1101 to start shifting in delay bits
                if (pattern_shift == 4'b1101) begin
                    next_state = SHIFT0;
                end
            end
            SHIFT0: next_state = SHIFT1;
            SHIFT1: next_state = SHIFT2;
            SHIFT2: next_state = SHIFT3;
            SHIFT3: next_state = COUNTING;
            COUNTING: begin
                if (done_counting) begin
                    next_state = DONE;
                end
            end
            DONE: begin
                if (ack) begin
                    next_state = SEARCH;
                end
            end
            default: next_state = SEARCH;
        endcase
    end

endmodule