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
        IDLE = 2'd0,
        SHIFT = 2'd1,
        COUNTING = 2'd2,
        DONE = 2'd3
    } state_t;

    state_t state, next_state;

    reg [3:0] shift_reg; // for detecting pattern 1101
    reg [2:0] shift_cnt; // counts 4 cycles in SHIFT state

    // Sequential logic: state and shift register update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            shift_cnt <= 3'd0;
        end else begin
            state <= next_state;

            if (state == IDLE) begin
                // Shift in the new data bit
                shift_reg <= {shift_reg[2:0], data};
            end else if (state == SHIFT) begin
                // counting cycles in SHIFT state
                shift_cnt <= shift_cnt + 1;
            end else begin
                shift_cnt <= 3'd0;
            end
        end
    end

    // Combinational next state logic and outputs
    always @(*) begin
        // Default outputs
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;
        next_state = state;

        case(state)
            IDLE: begin
                if (shift_reg == 4'b1101) begin
                    // pattern detected
                    next_state = SHIFT;
                end
            end

            SHIFT: begin
                shift_ena = 1'b1;
                if (shift_cnt == 3'd3) begin
                    // completed 4 cycles (count from 0 to 3)
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

            default: next_state = IDLE;
        endcase
    end

endmodule