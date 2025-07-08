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

    // FSM states
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        SHIFT = 2'b01,
        COUNT = 2'b10,
        DONE  = 2'b11
    } state_t;

    state_t state, next_state;

    reg [3:0] shift_reg;      // shift register to detect pattern 1101
    reg [2:0] shift_count;    // counts 4 shift cycles in SHIFT state

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

            // Shift in data in IDLE and SHIFT states only
            if (state == IDLE || state == SHIFT) begin
                shift_reg <= {shift_reg[2:0], data};
            end

            // Count the 4 shift cycles during SHIFT state
            if (state == SHIFT) begin
                shift_count <= shift_count + 1'b1;
            end else begin
                shift_count <= 3'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        // Default values
        next_state = state;

        case (state)
            IDLE: begin
                if (shift_reg == PATTERN)
                    next_state = SHIFT;
            end
            SHIFT: begin
                if (shift_count == 3'd3)
                    next_state = COUNT;
            end
            COUNT: begin
                if (done_counting)
                    next_state = DONE;
            end
            DONE: begin
                if (ack)
                    next_state = IDLE;
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
            COUNT: counting = 1'b1;
            DONE:  done = 1'b1;
        endcase
    end

endmodule