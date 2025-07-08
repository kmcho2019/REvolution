module TopModule(
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
    typedef enum reg [1:0] {
        IDLE = 2'd0,
        SHIFT = 2'd1,
        COUNT = 2'd2,
        DONE = 2'd3
    } state_t;

    state_t state, next_state;

    reg [3:0] shift_reg;   // to detect pattern 1101
    reg [2:0] shift_cnt;   // to count 4 shift cycles

    // Pattern to detect: 1101
    localparam [3:0] PATTERN = 4'b1101;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'd0;
            shift_cnt <= 3'd0;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    // Shift data into shift_reg
                    shift_reg <= {shift_reg[2:0], data};
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    shift_cnt <= 3'd0;
                end
                SHIFT: begin
                    // Continue shifting in 4 bits while asserting shift_ena
                    shift_ena <= 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;
                    shift_reg <= {shift_reg[2:0], data};
                    shift_cnt <= shift_cnt + 1'b1;
                end
                COUNT: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b1;
                    done <= 1'b0;
                    // shift_reg and shift_cnt hold their values
                end
                DONE: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b1;
                    // shift_reg and shift_cnt hold their values
                end
                default: begin
                    // should never happen
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    shift_reg <= 4'd0;
                    shift_cnt <= 3'd0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (shift_reg == PATTERN)
                    next_state = SHIFT;
                else
                    next_state = IDLE;
            end
            SHIFT: begin
                if (shift_cnt == 3'd3) // After 4 cycles (0 to 3)
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end
            COUNT: begin
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end
            DONE: begin
                if (ack)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule