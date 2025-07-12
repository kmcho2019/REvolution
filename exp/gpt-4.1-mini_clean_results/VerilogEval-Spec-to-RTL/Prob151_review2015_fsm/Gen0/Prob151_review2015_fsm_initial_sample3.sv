module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output reg  shift_ena,
    output reg  counting,
    output reg  done
);

    // States
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        SHIFT = 2'b01,
        COUNT = 2'b10,
        DONE  = 2'b11
    } state_t;

    state_t state, next_state;

    // Shift register for pattern detection
    reg [3:0] pattern_shift;

    // Counter for shift_ena cycles (4 cycles)
    reg [2:0] shift_count;

    // Pattern to detect: 1101 (binary)
    localparam [3:0] PATTERN = 4'b1101;

    // Sequential logic: state and shift register update
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

            case(state)
                IDLE: begin
                    // Shift in incoming data to detect pattern
                    pattern_shift <= {pattern_shift[2:0], data};
                    // outputs low in IDLE
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
                SHIFT: begin
                    // Continue shifting count of 4 cycles
                    pattern_shift <= pattern_shift; // no update, data path is outside FSM
                    shift_ena <= 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;

                    if (shift_count != 3'd4)
                        shift_count <= shift_count + 1'b1;
                    else
                        shift_count <= shift_count; // hold at 4 until state change
                end
                COUNT: begin
                    pattern_shift <= pattern_shift;
                    shift_ena <= 1'b0;
                    counting <= 1'b1;
                    done <= 1'b0;
                end
                DONE: begin
                    pattern_shift <= pattern_shift;
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (pattern_shift == PATTERN)
                    next_state = SHIFT;
                else
                    next_state = IDLE;
            end
            SHIFT: begin
                if (shift_count == 3'd4)
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

    // Reset shift_count when entering SHIFT state
    always @(posedge clk) begin
        if (reset) begin
            shift_count <= 3'd0;
        end else if (state != SHIFT && next_state == SHIFT) begin
            shift_count <= 3'd0;
        end
    end

endmodule