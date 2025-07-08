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
    typedef enum reg [1:0] {
        IDLE  = 2'd0,
        SHIFT = 2'd1,
        COUNT = 2'd2,
        DONE  = 2'd3
    } state_t;

    state_t state, next_state;

    // Shift register to detect pattern 1101
    reg [3:0] pattern_shift;

    // Counter for shift_ena cycles (4 cycles)
    reg [2:0] shift_count;

    // Sequential logic: state transition and pattern shift register update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0000;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;

            // Shift in data only in IDLE state to detect pattern
            if (state == IDLE) begin
                pattern_shift <= {pattern_shift[2:0], data};
            end else begin
                // In other states, pattern_shift remains unchanged
                pattern_shift <= pattern_shift;
            end

            // Manage shift_count in SHIFT state
            if (state == SHIFT) begin
                shift_count <= shift_count + 1;
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
                if (pattern_shift == 4'b1101) begin
                    next_state = SHIFT;
                end
            end
            SHIFT: begin
                if (shift_count == 3'd3) begin // after 4 cycles (count 0..3)
                    next_state = COUNT;
                end
            end
            COUNT: begin
                if (done_counting) begin
                    next_state = DONE;
                end
            end
            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    // Output logic
    always @(*) begin
        // Defaults
        shift_ena = 1'b0;
        counting  = 1'b0;
        done      = 1'b0;

        case (state)
            SHIFT: shift_ena = 1'b1;
            COUNT: counting  = 1'b1;
            DONE:  done      = 1'b1;
            default: ;
        endcase
    end

endmodule