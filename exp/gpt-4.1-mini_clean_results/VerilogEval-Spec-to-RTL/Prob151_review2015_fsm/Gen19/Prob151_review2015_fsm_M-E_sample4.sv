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

    // State encoding (3 bits, binary encoded)
    localparam SEARCH = 3'd0;
    localparam SHIFT  = 3'd1;
    localparam COUNT  = 3'd2;
    localparam DONE   = 3'd3;

    reg [2:0] state, next_state;

    // Shift register for pattern detection (4 bits)
    reg [3:0] pattern_shift;

    // 2-bit shift counter for the 4 shift cycles
    reg [1:0] shift_cnt, next_shift_cnt;

    // Pattern detection combinational: check if pattern_shift == 4'b1101
    wire pattern_detected = (pattern_shift == 4'b1101);

    // Sequential logic: pattern shift register and FSM state & shift counter update
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift <= 4'b0000;
            state        <= SEARCH;
            shift_cnt    <= 2'd0;
        end else begin
            // Shift in data bit for pattern detection on every clock
            pattern_shift <= {pattern_shift[2:0], data};
            state        <= next_state;
            shift_cnt    <= next_shift_cnt;
        end
    end

    // Next state and next shift counter logic
    always @(*) begin
        // Defaults
        next_state = state;
        next_shift_cnt = shift_cnt;

        case (state)
            SEARCH: begin
                // Wait for pattern to be detected
                if (pattern_detected)
                    next_state = SHIFT;
                // No shift counter used in SEARCH, reset to 0
                next_shift_cnt = 2'd0;
            end

            SHIFT: begin
                shift_ena = 1'b1; // asserted while shifting
                if (shift_cnt == 2'd3) begin
                    next_state = COUNT;
                    next_shift_cnt = 2'd0; // reset counter for next use
                end else begin
                    next_shift_cnt = shift_cnt + 1'b1;
                end
            end

            COUNT: begin
                shift_ena = 1'b0;
                counting = 1'b1;
                if (done_counting)
                    next_state = DONE;
            end

            DONE: begin
                shift_ena = 1'b0;
                counting = 1'b0;
                done = 1'b1;
                if (ack)
                    next_state = SEARCH;
            end

            default: begin
                next_state = SEARCH;
                next_shift_cnt = 2'd0;
            end
        endcase
    end

    // Output logic: assigned in a separate always block to avoid inferred latches and glitches
    always @(*) begin
        // Default outputs
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;

        case(state)
            SHIFT:    shift_ena = 1'b1;
            COUNT:    counting = 1'b1;
            DONE:     done     = 1'b1;
            default: ;
        endcase
    end

endmodule