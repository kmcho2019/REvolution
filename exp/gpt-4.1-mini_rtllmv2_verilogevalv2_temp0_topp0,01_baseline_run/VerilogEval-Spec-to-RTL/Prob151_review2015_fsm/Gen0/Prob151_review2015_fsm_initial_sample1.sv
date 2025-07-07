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
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        SHIFT = 2'b01,
        COUNT = 2'b10,
        DONE  = 2'b11
    } state_t;

    state_t state, next_state;

    // Shift register to detect pattern 1101
    reg [3:0] pattern_shift;

    // Counter for 4 shift cycles
    reg [1:0] shift_count;

    // Sequential logic for state and pattern_shift and shift_count
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0000;
            shift_count <= 2'b00;
        end else begin
            state <= next_state;

            if (state == IDLE) begin
                // Shift in data to detect pattern
                pattern_shift <= {pattern_shift[2:0], data};
            end else begin
                // In other states, pattern_shift is not used
                pattern_shift <= pattern_shift;
            end

            if (state == SHIFT) begin
                shift_count <= shift_count + 1;
            end else begin
                shift_count <= 2'b00;
            end
        end
    end

    // Next state logic
    always @(*) begin
        // Default next state is current state
        next_state = state;

        case (state)
            IDLE: begin
                if (pattern_shift == 4'b1101) begin
                    next_state = SHIFT;
                end
            end

            SHIFT: begin
                if (shift_count == 2'd3) begin
                    // After 4 cycles (count 0 to 3), go to COUNT
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

            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        // Default outputs
        shift_ena = 1'b0;
        counting  = 1'b0;
        done      = 1'b0;

        case (state)
            SHIFT: shift_ena = 1'b1;
            COUNT: counting  = 1'b1;
            DONE:  done      = 1'b1;
        endcase
    end

endmodule