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

    // Define states with sufficient bits
    typedef enum logic [1:0] {
        IDLE,
        SHIFT,
        COUNTING,
        DONE
    } state_t;

    reg [1:0] current_state, next_state;
    reg [2:0] shift_counter;
    reg [3:0] pattern_reg;  // Shift register for pattern detection

    // State transition and pattern detection
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            shift_counter <= 0;
            pattern_reg <= 4'b0;
        end else begin
            current_state <= next_state;
            
            // Update pattern detection shift register
            pattern_reg <= {pattern_reg[2:0], data};
            
            // Counter for SHIFT state
            if (current_state == SHIFT) begin
                shift_counter <= shift_counter + 1;
            end else begin
                shift_counter <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                // Detect 1101 pattern (MSB first)
                if (pattern_reg == 4'b1101) begin
                    next_state = SHIFT;
                end else begin
                    next_state = IDLE;
                end
            end
            
            SHIFT: begin
                if (shift_counter == 3) begin  // After 4 cycles (0-3)
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

    // Output logic - combinatorial
    always @(*) begin
        shift_ena = (current_state == SHIFT);
        counting = (current_state == COUNTING);
        done = (current_state == DONE);
    end

endmodule