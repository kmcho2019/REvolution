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

    // Shift register to detect pattern 1101, continuously shifts every clock
    reg [3:0] shift_reg;

    // Counter for 4 shift cycles during SHIFT state
    reg [2:0] shift_counter;

    // State register and synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Shift register always shifts in data every clock to detect pattern continuously
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0000;
        end else begin
            shift_reg <= {shift_reg[2:0], data};
        end
    end

    // Shift counter increments only in SHIFT state, reset otherwise
    always @(posedge clk) begin
        if (reset) begin
            shift_counter <= 3'd0;
        end else if (state == SHIFT) begin
            if (shift_counter < 3'd4)
                shift_counter <= shift_counter + 3'd1;
        end else begin
            shift_counter <= 3'd0;
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
                // After 4 shift cycles, move to COUNTING
                if (shift_counter == 3'd4)
                    next_state = COUNTING;
            end
            COUNTING: begin
                // Wait for done_counting signal
                if (done_counting)
                    next_state = DONE;
            end
            DONE: begin
                // Wait for ack signal to return to IDLE
                if (ack)
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic synchronous to state changes
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
                SHIFT: begin
                    // Assert shift_ena for exactly 4 cycles in SHIFT
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

endmodule