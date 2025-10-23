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

    // State encoding
    typedef enum logic [1:0] {
        IDLE     = 2'b00,
        SHIFT    = 2'b01,
        COUNTING = 2'b10,
        DONE     = 2'b11
    } state_t;

    state_t state, next_state;

    // 4-bit shift register for pattern detection
    reg [3:0] shift_reg;

    // 2-bit counter for SHIFT state duration (0 to 3)
    reg [1:0] shift_count;

    // Sequential logic: state, shift_reg, shift_count update, outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            shift_count <= 2'b0;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            // Shift in new data every cycle
            shift_reg <= {shift_reg[2:0], data};

            // State transition
            state <= next_state;

            // Shift count increments only in SHIFT state
            if (state == SHIFT)
                shift_count <= shift_count + 1'b1;
            else
                shift_count <= 2'b0;

            // Outputs are Moore style, depend on current state
            shift_ena <= (state == SHIFT);
            counting <= (state == COUNTING);
            done <= (state == DONE);
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state; // default hold

        case(state)
            IDLE: begin
                if (shift_reg == 4'b1101)
                    next_state = SHIFT;
            end
            SHIFT: begin
                if (shift_count == 2'd3) // after 4 cycles: counts 0,1,2,3
                    next_state = COUNTING;
            end
            COUNTING: begin
                if (done_counting)
                    next_state = DONE;
            end
            DONE: begin
                if (ack)
                    next_state = IDLE;
            end
        endcase
    end

endmodule