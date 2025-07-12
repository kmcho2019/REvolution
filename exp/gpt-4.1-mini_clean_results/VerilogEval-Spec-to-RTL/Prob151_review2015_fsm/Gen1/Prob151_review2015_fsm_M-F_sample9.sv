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

    reg [3:0] shift_reg;     // For detecting pattern 1101 continuously
    reg [1:0] shift_count;   // Count 4 cycles of shifting during SHIFT state

    // Sequential block for state, shift_reg, and counters
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0000;
            shift_count <= 2'b00;
        end else begin
            state <= next_state;

            // Always shift in data every clock cycle
            shift_reg <= {shift_reg[2:0], data};

            case (next_state)
                IDLE: begin
                    shift_count <= 2'b00;
                end
                SHIFT: begin
                    // Increment shift_count every cycle in SHIFT state
                    if (state == SHIFT) begin
                        shift_count <= shift_count + 1;
                    end else begin
                        // Just entered SHIFT state, reset counter to zero
                        shift_count <= 2'b00;
                    end
                end
                default: begin
                    shift_count <= 2'b00;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;

        case (state)
            IDLE: begin
                // Detect pattern 1101 on shift_reg to start SHIFT
                if (shift_reg == 4'b1101) begin
                    next_state = SHIFT;
                end
            end
            SHIFT: begin
                // After 4 shift cycles (count 0 to 3), move to COUNTING
                if (shift_count == 2'd3) begin
                    next_state = COUNTING;
                end
            end
            COUNTING: begin
                if (done_counting) begin
                    next_state = DONE;
                end
            end
            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic driven from registered state (synchronous)
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            // Defaults off
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;

            case (state)
                SHIFT: shift_ena <= 1'b1;
                COUNTING: counting <= 1'b1;
                DONE: done <= 1'b1;
            endcase
        end
    end

endmodule