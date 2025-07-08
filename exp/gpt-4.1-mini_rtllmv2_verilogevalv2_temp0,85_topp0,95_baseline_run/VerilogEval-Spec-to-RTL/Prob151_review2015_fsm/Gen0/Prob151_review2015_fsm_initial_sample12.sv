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
    typedef enum logic [2:0] {
        IDLE = 3'd0,
        SHIFT = 3'd1,
        WAIT_COUNT = 3'd2,
        DONE_WAIT_ACK = 3'd3
    } state_t;

    state_t state, next_state;

    // For pattern detection: we keep a 4-bit shift register of last 4 bits
    reg [3:0] pattern_shift;

    // Counter for shift cycles (4 cycles)
    reg [2:0] shift_cnt;

    // Pattern to detect
    localparam [3:0] PATTERN = 4'b1101;

    // Next state logic and output logic combined in always_ff block
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0000;
            shift_cnt <= 3'd0;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    shift_ena <= 1'b0;

                    // Shift in data bit to pattern_shift (left shift, new bit on LSB)
                    pattern_shift <= {pattern_shift[2:0], data};

                    // If pattern detected, move to SHIFT state
                    if (pattern_shift == PATTERN) begin
                        state <= SHIFT;
                        shift_cnt <= 3'd0;
                        shift_ena <= 1'b1;
                    end else begin
                        state <= IDLE;
                    end
                end

                SHIFT: begin
                    // Keep shifting 4 bits
                    shift_ena <= 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;

                    shift_cnt <= shift_cnt + 1;

                    if (shift_cnt == 3'd3) begin
                        // After 4 cycles, stop shifting, start counting
                        shift_ena <= 1'b0;
                        counting <= 1'b1;
                        state <= WAIT_COUNT;
                    end else begin
                        state <= SHIFT;
                    end

                    // Continue shifting in pattern_shift to not lose tracking pattern in IDLE
                    pattern_shift <= {pattern_shift[2:0], data};
                end

                WAIT_COUNT: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Keep shifting pattern_shift to allow detection after done
                    pattern_shift <= {pattern_shift[2:0], data};

                    if (done_counting) begin
                        counting <= 1'b0;
                        done <= 1'b1;
                        state <= DONE_WAIT_ACK;
                    end else begin
                        state <= WAIT_COUNT;
                    end
                end

                DONE_WAIT_ACK: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b1;

                    // Shift pattern_shift as usual
                    pattern_shift <= {pattern_shift[2:0], data};

                    if (ack) begin
                        done <= 1'b0;
                        state <= IDLE;
                    end else begin
                        state <= DONE_WAIT_ACK;
                    end
                end

                default: begin
                    state <= IDLE;
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    pattern_shift <= 4'b0000;
                    shift_cnt <= 3'd0;
                end
            endcase
        end
    end

endmodule