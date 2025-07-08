module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE   = 2'b00,
        SHIFT  = 2'b01,
        COUNT  = 2'b10,
        DONE_S = 2'b11
    } state_t;

    state_t state, next_state;

    reg [3:0] shift_reg;       // to detect pattern 1101
    reg [2:0] shift_count;     // count 4 shift cycles

    // Pattern to detect
    localparam [3:0] PATTERN = 4'b1101;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0000;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;

            // Shift register for pattern detection only in IDLE
            if (state == IDLE) begin
                shift_reg <= {shift_reg[2:0], data};
            end

            // Count shift cycles in SHIFT state
            if (state == SHIFT) begin
                shift_count <= shift_count + 1;
            end else begin
                shift_count <= 3'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        // Default outputs and next state
        next_state = state;

        shift_ena = 1'b0;
        counting  = 1'b0;
        done      = 1'b0;

        case (state)
            IDLE: begin
                // shift_reg is updated in sequential block
                if (shift_reg == PATTERN) begin
                    next_state = SHIFT;
                end
            end

            SHIFT: begin
                shift_ena = 1'b1;
                if (shift_count == 3'd3) begin
                    // 4 cycles done
                    next_state = COUNT;
                end
            end

            COUNT: begin
                counting = 1'b1;
                if (done_counting) begin
                    next_state = DONE_S;
                end
            end

            DONE_S: begin
                done = 1'b1;
                if (ack) begin
                    next_state = IDLE;
                end
            end

            default: next_state = IDLE;
        endcase
    end

endmodule