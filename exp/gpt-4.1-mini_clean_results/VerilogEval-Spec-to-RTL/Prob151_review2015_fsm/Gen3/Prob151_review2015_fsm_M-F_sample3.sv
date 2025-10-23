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
        IDLE     = 2'b00,
        SHIFT    = 2'b01,
        COUNTING = 2'b10,
        DONE     = 2'b11
    } state_t;

    state_t state, next_state;

    // Shift register for pattern detection (1101)
    reg [3:0] shift_reg;

    // Shift counter: counts 0..3 during SHIFT state (4 cycles)
    reg [1:0] shift_counter;

    // State and registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            shift_counter <= 2'b0;

            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            // Shift in new data every clock (for pattern detection)
            shift_reg <= {shift_reg[2:0], data};

            // State update
            state <= next_state;

            // Shift counter increments only during SHIFT state
            if (state == SHIFT)
                shift_counter <= shift_counter + 1'b1;
            else
                shift_counter <= 2'b0;

            // Moore outputs based on current state (after update)
            case (next_state)
                IDLE: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
                SHIFT: begin
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

    // Next state combinational logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            IDLE: begin
                // Detect pattern 1101 to start shifting
                if (shift_reg == 4'b1101)
                    next_state = SHIFT;
            end
            SHIFT: begin
                // After 4 cycles of shifting (shift_counter counts 0..3), move to COUNTING
                if (shift_counter == 2'd3)
                    next_state = COUNTING;
            end
            COUNTING: begin
                // Wait for done_counting to go high
                if (done_counting)
                    next_state = DONE;
            end
            DONE: begin
                // Wait for ack before returning to IDLE
                if (ack)
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule