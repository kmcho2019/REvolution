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
    typedef enum logic [2:0] {
        SEARCH  = 3'd0,
        SHIFT_0 = 3'd1,
        SHIFT_1 = 3'd2,
        SHIFT_2 = 3'd3,
        SHIFT_3 = 3'd4,
        COUNTING= 3'd5,
        DONE    = 3'd6
    } state_t;

    state_t state, next_state;

    // 4-bit pattern shift register for detection (valid only in SEARCH)
    reg [3:0] pattern_reg;

    // Synchronous state and pattern_reg update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_reg <= 4'b0000;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Only shift pattern_reg in SEARCH state
            if (state == SEARCH)
                pattern_reg <= {pattern_reg[2:0], data};
            else
                pattern_reg <= pattern_reg; // hold pattern_reg outside SEARCH

            // Moore outputs based on current state
            case (state)
                SEARCH: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
                SHIFT_0, SHIFT_1, SHIFT_2, SHIFT_3: begin
                    shift_ena <= 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
                COUNTING: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b1;
                    done <= 1'b0;
                end
                DONE: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b1;
                end
                default: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state; // default hold

        case (state)
            SEARCH: begin
                // Detect pattern 1101
                if (pattern_reg == 4'b1101)
                    next_state = SHIFT_0;
                else
                    next_state = SEARCH;
            end
            SHIFT_0: next_state = SHIFT_1;
            SHIFT_1: next_state = SHIFT_2;
            SHIFT_2: next_state = SHIFT_3;
            SHIFT_3: next_state = COUNTING;
            COUNTING: begin
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNTING;
            end
            DONE: begin
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = DONE;
            end
            default: next_state = SEARCH;
        endcase
    end

endmodule