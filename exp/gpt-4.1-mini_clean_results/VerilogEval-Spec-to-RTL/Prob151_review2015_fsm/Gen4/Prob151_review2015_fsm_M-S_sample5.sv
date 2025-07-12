module TopModule(
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
        SEARCH     = 2'd0,
        SHIFT      = 2'd1,
        WAIT_COUNT = 2'd2,
        WAIT_ACK   = 2'd3
    } state_t;

    state_t state, next_state;

    reg [3:0] shift_reg;      // For pattern detection
    reg [1:0] shift_cnt;      // Counts 0 to 3 during SHIFT state (4 cycles)

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                if (shift_reg == 4'b1101)
                    next_state = SHIFT;
            end
            SHIFT: begin
                if (shift_cnt == 2'd3)
                    next_state = WAIT_COUNT;
            end
            WAIT_COUNT: begin
                if (done_counting)
                    next_state = WAIT_ACK;
            end
            WAIT_ACK: begin
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state      <= SEARCH;
            shift_reg  <= 4'd0;
            shift_cnt  <= 2'd0;
            shift_ena  <= 1'b0;
            counting   <= 1'b0;
            done       <= 1'b0;
        end else begin
            state <= next_state;

            // Shift in data every cycle for pattern detection only in SEARCH
            if (state == SEARCH)
                shift_reg <= {shift_reg[2:0], data};

            // shift_cnt increments only in SHIFT
            if (state == SHIFT)
                shift_cnt <= shift_cnt + 1'b1;
            else
                shift_cnt <= 2'd0;

            // Outputs driven by current state (Moore outputs)
            shift_ena <= (state == SHIFT);
            counting  <= (state == WAIT_COUNT);
            done      <= (state == WAIT_ACK);
        end
    end

endmodule