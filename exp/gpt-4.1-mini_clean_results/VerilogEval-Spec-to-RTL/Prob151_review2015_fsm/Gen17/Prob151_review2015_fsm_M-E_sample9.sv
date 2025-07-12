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

    // One-hot state encoding (5 states)
    localparam S_SEARCH = 5'b00001;
    localparam S_SHIFT  = 5'b00010;
    localparam S_COUNT  = 5'b00100;
    localparam S_DONE   = 5'b01000;

    reg [4:0] state, next_state;

    // 4-bit shift register for pattern detection (shift in data at each clock)
    reg [3:0] pattern_shift;

    // 3-bit shift counter (counts 0 to 3) during SHIFT state
    reg [2:0] shift_count;

    // Pattern to detect: 1101 (binary), MSB is oldest bit in pattern_shift
    wire pattern_detected = (pattern_shift == 4'b1101);

    // Sequential logic: state, pattern_shift, shift_count update
    always @(posedge clk) begin
        if (reset) begin
            state <= S_SEARCH;
            pattern_shift <= 4'b0000;
            shift_count <= 3'd0;
        end else begin
            // Shift pattern_shift with new data bit
            pattern_shift <= {pattern_shift[2:0], data};

            state <= next_state;

            if (state == S_SHIFT)
                shift_count <= shift_count + 3'd1;
            else
                shift_count <= 3'd0;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            S_SEARCH: begin
                if (pattern_detected)
                    next_state = S_SHIFT;
                else
                    next_state = S_SEARCH;
            end
            S_SHIFT: begin
                if (shift_count == 3'd3)
                    next_state = S_COUNT;
                else
                    next_state = S_SHIFT;
            end
            S_COUNT: begin
                if (done_counting)
                    next_state = S_DONE;
                else
                    next_state = S_COUNT;
            end
            S_DONE: begin
                if (ack)
                    next_state = S_SEARCH;
                else
                    next_state = S_DONE;
            end
            default: next_state = S_SEARCH;
        endcase
    end

    // Output logic (Moore outputs depending on state)
    always @(*) begin
        shift_ena = 1'b0;
        counting  = 1'b0;
        done      = 1'b0;

        case (state)
            S_SHIFT: shift_ena = 1'b1;
            S_COUNT: counting  = 1'b1;
            S_DONE:  done      = 1'b1;
            default: ;
        endcase
    end

endmodule