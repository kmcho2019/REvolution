module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // Define states
    typedef enum logic [1:0] {
        IDLE,
        SHIFT,
        COUNTING,
        DONE
    } state_t;

    state_t current_state, next_state;

    // Pattern detection shift register
    reg [3:0] pattern_reg;
    reg [1:0] shift_counter;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            pattern_reg <= 4'b0;
            shift_counter <= 2'b0;
        end else begin
            current_state <= next_state;
            pattern_reg <= {pattern_reg[2:0], data};

            if (current_state == SHIFT) begin
                shift_counter <= shift_counter + 1;
            end else begin
                shift_counter <= 2'b0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (pattern_reg == 4'b1101) begin
                    next_state = SHIFT;
                end else begin
                    next_state = IDLE;
                end
            end
            SHIFT: begin
                if (shift_counter == 2'b11) begin  // After 4 cycles (0-3)
                    next_state = COUNTING;
                end else begin
                    next_state = SHIFT;
                end
            end
            COUNTING: begin
                if (done_counting) begin
                    next_state = DONE;
                end else begin
                    next_state = COUNTING;
                end
            end
            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                end else begin
                    next_state = DONE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        shift_ena = (current_state == SHIFT);
        counting = (current_state == COUNTING);
        done = (current_state == DONE);
    end

endmodule