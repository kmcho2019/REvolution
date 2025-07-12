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
    reg [1:0] shift_count;   // Counts 0..3 for 4 cycles in SHIFT

    // Sequential logic: state, shift_reg, shift_count, and outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0000;
            shift_count <= 2'b00;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Update shift_reg only during IDLE and SHIFT states
            if (state == IDLE || state == SHIFT) begin
                shift_reg <= {shift_reg[2:0], data};
            end

            // shift_count increments during SHIFT, else reset
            if (state == SHIFT) begin
                shift_count <= shift_count + 1;
            end else begin
                shift_count <= 2'b00;
            end

            // Outputs synchronous and based on current state
            shift_ena <= (state == SHIFT);
            counting <= (state == COUNTING);
            done <= (state == DONE);
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                // Detect pattern 1101 in shift_reg
                if (shift_reg == 4'b1101) begin
                    next_state = SHIFT;
                end
            end
            SHIFT: begin
                // After exactly 4 cycles assert shift_ena, move to COUNTING
                if (shift_count == 2'd3) begin
                    next_state = COUNTING;
                end
            end
            COUNTING: begin
                // Wait for done_counting to go high
                if (done_counting) begin
                    next_state = DONE;
                end
            end
            DONE: begin
                // Wait for ack, then return to IDLE
                if (ack) begin
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

endmodule