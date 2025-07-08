module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // FSM States
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        SHIFT = 2'b01,
        COUNT = 2'b10,
        DONE  = 2'b11
    } state_t;

    state_t state, next_state;

    // Shift register to detect pattern 1101
    reg [3:0] pattern_shift_reg;

    // Counter for shift_ena cycles (4 cycles)
    reg [1:0] shift_count;

    // Synchronous state and registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift_reg <= 4'b0000;
            shift_count <= 2'b00;
        end else begin
            state <= next_state;

            if (state == IDLE) begin
                // Shift in data
                pattern_shift_reg <= {pattern_shift_reg[2:0], data};
            end

            if (state == SHIFT) begin
                // Count the 4 shift cycles
                shift_count <= shift_count + 1;
            end else begin
                shift_count <= 2'b00;
            end
        end
    end

    // Next state logic and outputs
    always @(*) begin
        // Default outputs
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;
        next_state = state;

        case (state)
            IDLE: begin
                // Wait for pattern 1101
                if (pattern_shift_reg == 4'b1101) begin
                    next_state = SHIFT;
                end
            end

            SHIFT: begin
                shift_ena = 1'b1;
                if (shift_count == 2'd3) begin
                    // After 4 cycles, go to COUNT
                    next_state = COUNT;
                end
            end

            COUNT: begin
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