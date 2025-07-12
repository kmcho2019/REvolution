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
    // FSM states
    typedef enum logic [1:0] {
        IDLE     = 2'b00,
        SHIFT    = 2'b01,
        COUNTING = 2'b10,
        DONE     = 2'b11
    } state_t;

    state_t state, next_state;

    reg [3:0] shift_reg;     // to detect pattern 1101
    reg [2:0] shift_count;   // count 4 shift cycles in SHIFT state

    // Sequential: state and shift register update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0000;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;

            if (state == IDLE) begin
                // Shift in new bit to detect pattern 1101
                shift_reg <= {shift_reg[2:0], data};
            end else if (state == SHIFT) begin
                shift_count <= shift_count + 3'd1;
            end else begin
                shift_count <= 3'd0;  // reset count outside SHIFT state
            end
        end
    end

    // Next state logic and outputs
    always @(*) begin
        // Default output signals
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;
        next_state = state;

        case (state)
            IDLE: begin
                // Look for pattern 1101
                if (shift_reg == 4'b1101) begin
                    next_state = SHIFT;
                    // shift_count reset handled in sequential block
                end
            end

            SHIFT: begin
                shift_ena = 1'b1;
                if (shift_count == 3'd3) begin
                    // After 4 cycles of shift (count from 0 to 3)
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
        endcase
    end

endmodule