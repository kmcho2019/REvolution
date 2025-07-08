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

    reg [3:0] shift_reg;  // to detect pattern 1101
    reg [1:0] shift_count; // count 4 shift cycles

    // Sequential logic: state and shift_reg update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0000;
            shift_count <= 2'b00;
        end else begin
            state <= next_state;

            // Shift in data in IDLE and SHIFT states
            if (state == IDLE || state == SHIFT) begin
                shift_reg <= {shift_reg[2:0], data};
            end

            // Count shift cycles in SHIFT state
            if (state == SHIFT) begin
                shift_count <= shift_count + 1;
            end else begin
                shift_count <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        // default next state is current state
        next_state = state;

        case(state)
            IDLE: begin
                // Look for pattern 1101 in shift_reg
                if (shift_reg == 4'b1101) begin
                    next_state = SHIFT;
                end
            end

            SHIFT: begin
                if (shift_count == 2'd3) begin
                    // after 4 shift cycles (count from 0 to 3), go to COUNT
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

    // Output logic (Moore)
    always @(*) begin
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;

        case(state)
            SHIFT: shift_ena = 1'b1;
            COUNT: counting = 1'b1;
            DONE:  done = 1'b1;
        endcase
    end

endmodule