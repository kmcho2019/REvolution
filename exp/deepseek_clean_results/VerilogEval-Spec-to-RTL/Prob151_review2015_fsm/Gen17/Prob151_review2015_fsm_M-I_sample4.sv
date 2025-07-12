module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE,
        SHIFT,
        COUNTING,
        DONE
    } state_t;

    state_t state, next_state;
    reg [1:0] shift_cnt;
    reg [3:0] pattern;

    // Next state logic
    always_comb begin
        next_state = state;
        case (state)
            IDLE: 
                if (pattern == 4'b1101)
                    next_state = SHIFT;

            SHIFT:
                if (shift_cnt == 2'd3)
                    next_state = COUNTING;

            COUNTING:
                if (done_counting)
                    next_state = DONE;

            DONE:
                if (ack)
                    next_state = IDLE;

            default:
                next_state = IDLE;
        endcase
    end

    // Sequential logic
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_cnt <= 2'b0;
            pattern <= 4'b0;
        end else begin
            state <= next_state;

            // Pattern register update
            if (state == IDLE) begin
                pattern <= {pattern[2:0], data};
            end else begin
                pattern <= 4'b0;
            end

            // Shift counter update
            if (state == SHIFT) begin
                if (state != next_state) // Just entered SHIFT
                    shift_cnt <= 2'b0;
                else
                    shift_cnt <= shift_cnt + 1;
            end else begin
                shift_cnt <= 2'b0;
            end
        end
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting = (state == COUNTING);
    assign done = (state == DONE);

endmodule