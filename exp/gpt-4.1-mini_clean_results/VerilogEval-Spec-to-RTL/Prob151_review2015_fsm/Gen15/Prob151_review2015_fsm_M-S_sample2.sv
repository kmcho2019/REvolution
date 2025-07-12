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

    // States: IDLE (search), SHIFT (shift 4 bits), COUNT (wait counting), DONE (wait ack)
    typedef enum reg [1:0] {
        IDLE  = 2'd0,
        SHIFT = 2'd1,
        COUNT = 2'd2,
        DONE  = 2'd3
    } state_t;

    reg [1:0] state, next_state;

    reg [1:0] shift_count, next_shift_count;
    reg [3:0] pattern_shift; // to detect pattern 1101

    // Next state logic and counters
    always @(*) begin
        next_state = state;
        next_shift_count = shift_count;

        case (state)
            IDLE: begin
                // Shift in data for pattern detection
                if (pattern_shift == 4'b1101)
                    next_state = SHIFT;
                next_shift_count = 2'd0;
            end
            SHIFT: begin
                if (shift_count == 2'd3)
                    next_state = COUNT;
                next_shift_count = shift_count + 2'd1;
            end
            COUNT: begin
                if (done_counting)
                    next_state = DONE;
                next_shift_count = 2'd0;
            end
            DONE: begin
                if (ack)
                    next_state = IDLE;
                next_shift_count = 2'd0;
            end
        endcase
    end

    // Sequential logic for state, counters, and pattern shift register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 2'd0;
            pattern_shift <= 4'b0000;
        end else begin
            state <= next_state;
            shift_count <= next_shift_count;
            if (state == IDLE)
                pattern_shift <= {pattern_shift[2:0], data};
            else
                pattern_shift <= 4'b0000; // don't update pattern_shift outside IDLE
        end
    end

    // Output logic
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule