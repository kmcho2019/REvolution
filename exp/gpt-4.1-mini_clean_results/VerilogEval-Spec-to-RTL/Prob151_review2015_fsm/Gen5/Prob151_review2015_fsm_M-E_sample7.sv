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
        IDLE     = 2'd0,
        SHIFT    = 2'd1,
        COUNTING = 2'd2,
        DONE     = 2'd3
    } state_t;

    state_t state, next_state;

    // 4-bit pattern shift register (always shifts data each clk)
    reg [3:0] pattern_reg;

    // 2-bit shift counter for SHIFT state (counts 1 to 4)
    reg [1:0] shift_cnt, shift_cnt_next;

    // Sequential logic: state, pattern_reg, shift_cnt update
    always @(posedge clk) begin
        if (reset) begin
            state       <= IDLE;
            pattern_reg <= 4'b0000;
            shift_cnt   <= 2'd0;
        end else begin
            state       <= next_state;
            pattern_reg <= {pattern_reg[2:0], data};
            shift_cnt   <= shift_cnt_next;
        end
    end

    // Next state and shift_cnt logic
    always @(*) begin
        next_state = state;
        shift_cnt_next = shift_cnt;

        case(state)
            IDLE: begin
                shift_cnt_next = 2'd0;
                // Detect pattern 1101 to start shifting
                if (pattern_reg == 4'b1101)
                    next_state = SHIFT;
                else
                    next_state = IDLE;
            end

            SHIFT: begin
                // increment shift_cnt each cycle until 4 shifts done
                if (shift_cnt == 2'd4)
                    next_state = COUNTING;
                else begin
                    shift_cnt_next = shift_cnt + 1;
                    next_state = SHIFT;
                end
            end

            COUNTING: begin
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNTING;
                shift_cnt_next = 2'd0;
            end

            DONE: begin
                if (ack)
                    next_state = IDLE;
                else
                    next_state = DONE;
                shift_cnt_next = 2'd0;
            end

            default: begin
                next_state = IDLE;
                shift_cnt_next = 2'd0;
            end
        endcase
    end

    // Output logic (Mealy style): combinational, based on state and shift_cnt
    always @(*) begin
        shift_ena = 1'b0;
        counting  = 1'b0;
        done      = 1'b0;

        case(state)
            IDLE: begin
                // No outputs asserted in IDLE
                shift_ena = 1'b0;
                counting  = 1'b0;
                done      = 1'b0;
            end

            SHIFT: begin
                // Assert shift_ena for shift_cnt = 1 to 4 cycles inclusive
                // Since shift_cnt starts at 0, we assert shift_ena when shift_cnt < 4
                if (shift_cnt < 2'd4)
                    shift_ena = 1'b1;
                else
                    shift_ena = 1'b0;
                counting = 1'b0;
                done = 1'b0;
            end

            COUNTING: begin
                shift_ena = 1'b0;
                counting  = 1'b1;
                done      = 1'b0;
            end

            DONE: begin
                shift_ena = 1'b0;
                counting  = 1'b0;
                done      = 1'b1;
            end

            default: begin
                shift_ena = 1'b0;
                counting  = 1'b0;
                done      = 1'b0;
            end
        endcase
    end

endmodule