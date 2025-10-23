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
    typedef enum reg [2:0] {
        IDLE     = 3'd0,
        SHIFT    = 3'd1,
        COUNTING = 3'd2,
        DONE     = 3'd3
    } state_t;

    reg [2:0] state, next_state;

    // Shift register to detect pattern 1101 (4 bits)
    reg [3:0] pattern_shift;

    // Counter for SHIFT state (counts 4 clock cycles)
    reg [2:0] shift_count;

    // Pattern constant
    localparam [3:0] PATTERN = 4'b1101;

    // Sequential logic for state and pattern_shift and shift_count
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0000;
            shift_count <= 3'd0;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Shift pattern register on every clock in all states except reset
            // Shift left, append new data bit at LSB
            pattern_shift <= {pattern_shift[2:0], data};

            case (next_state)
                IDLE: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    shift_count <= 3'd0;
                end
                SHIFT: begin
                    shift_ena <= 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;
                    if (state != SHIFT)
                        shift_count <= 3'd1;
                    else
                        shift_count <= shift_count + 3'd1;
                end
                COUNTING: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b1;
                    done <= 1'b0;
                    shift_count <= 3'd0;
                end
                DONE: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b1;
                    shift_count <= 3'd0;
                end
                default: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    shift_count <= 3'd0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (pattern_shift == PATTERN)
                    next_state = SHIFT;
                else
                    next_state = IDLE;
            end
            SHIFT: begin
                if (shift_count == 3'd4)
                    next_state = COUNTING;
                else
                    next_state = SHIFT;
            end
            COUNTING: begin
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNTING;
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