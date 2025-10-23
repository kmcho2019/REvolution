module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

    // Define states
    typedef enum logic [1:0] {
        IDLE,
        SHIFT,
        COUNT,
        DONE
    } state_t;

    // State registers
    state_t current_state, next_state;

    // Pattern detection registers
    reg [3:0] pattern_reg;
    reg [1:0] shift_counter;

    // Synchronous state transition
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            pattern_reg <= 4'b0;
            shift_counter <= 2'b0;
        end else begin
            current_state <= next_state;
            
            // Shift in data for pattern detection
            pattern_reg <= {pattern_reg[2:0], data};
            
            // Count shift cycles
            if (current_state == SHIFT) begin
                shift_counter <= shift_counter + 1;
            end else begin
                shift_counter <= 2'b0;
            end
        end
    end

    // Next state logic
    always_comb begin
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
                    next_state = COUNT;
                end else begin
                    next_state = SHIFT;
                end
            end
            
            COUNT: begin
                if (done_counting) begin
                    next_state = DONE;
                end else begin
                    next_state = COUNT;
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
    assign shift_ena = (current_state == SHIFT);
    assign counting = (current_state == COUNT);
    assign done = (current_state == DONE);

endmodule