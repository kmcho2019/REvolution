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

    // Shift register to detect pattern 1101
    reg [3:0] shift_reg;

    // Counter for 4 shift_ena cycles
    reg [2:0] shift_counter; // 3 bits enough for count to 4

    // Sequential logic for state and shift_reg
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0000;
            shift_counter <= 3'd0;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Shift register shifts in data every clock in IDLE and SHIFT states
            // For IDLE: always shift data to detect pattern
            // For SHIFT: shift occurs when shift_ena is asserted
            if (state == IDLE) begin
                shift_reg <= {shift_reg[2:0], data};
            end else if (state == SHIFT) begin
                // shift_reg updated only if shift_ena is asserted,
                // shift_ena should be asserted all 4 cycles in SHIFT state
                if (shift_ena) begin
                    shift_reg <= {shift_reg[2:0], data};
                end
            end else begin
                // In other states do not shift
                shift_reg <= shift_reg;
            end

            // Shift counter update in SHIFT state
            if (state == SHIFT) begin
                if (shift_ena)
                    shift_counter <= shift_counter + 3'd1;
            end else begin
                shift_counter <= 3'd0;
            end

            // Outputs controlled by state
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
            endcase
        end
    end

    // Combinational logic to determine next_state
    always @(*) begin
        next_state = state; // default hold state

        case (state)
            IDLE: begin
                // Check for pattern 1101 in shift_reg
                if (shift_reg == 4'b1101)
                    next_state = SHIFT;
            end
            SHIFT: begin
                // After 4 shift cycles, move to COUNTING
                if (shift_counter == 3'd4)
                    next_state = COUNTING;
            end
            COUNTING: begin
                // Wait until done_counting goes high
                if (done_counting)
                    next_state = DONE;
            end
            DONE: begin
                // Wait until ack goes high to reset to IDLE
                if (ack)
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule