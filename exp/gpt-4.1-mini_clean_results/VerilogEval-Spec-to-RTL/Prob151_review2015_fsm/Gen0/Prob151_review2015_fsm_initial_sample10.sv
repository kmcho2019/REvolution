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

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        SHIFT = 2'b01,
        COUNTING = 2'b10,
        DONE = 2'b11
    } state_t;

    state_t state, next_state;

    reg [3:0] shift_reg;     // For detecting pattern 1101
    reg [1:0] shift_count;   // Count 4 cycles of shifting during SHIFT state

    // Sequential block for state and registers
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0000;
            shift_count <= 2'b00;
        end else begin
            state <= next_state;
            // Shift pattern detection register always shifts in data in all states except when reset
            if (state == IDLE) begin
                shift_reg <= {shift_reg[2:0], data};
            end
            // In SHIFT state count shift cycles
            if (state == SHIFT) begin
                shift_count <= shift_count + 1;
            end else begin
                shift_count <= 2'b00;
            end
        end
    end

    // Next state logic
    always @(*) begin
        // Default assignments
        next_state = state;

        case (state)
            IDLE: begin
                // Check for pattern 1101 in shift_reg after shift
                if (shift_reg == 4'b1101) begin
                    next_state = SHIFT;
                end
            end
            SHIFT: begin
                // After exactly 4 shift cycles move to COUNTING
                if (shift_count == 2'd3) begin
                    next_state = COUNTING;
                end
            end
            COUNTING: begin
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
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;

        case (state)
            SHIFT: shift_ena = 1'b1;
            COUNTING: counting = 1'b1;
            DONE: done = 1'b1;
        endcase
    end

endmodule