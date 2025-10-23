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

    // State encoding
    typedef enum logic [1:0] {
        S_IDLE,
        S_SHIFT,
        S_COUNT,
        S_DONE
    } state_t;

    reg [1:0] current_state, next_state;
    reg [2:0] shift_counter;  // Now 3-bit for clearer counting (0-3)
    reg [3:0] pattern_reg;

    // Continuous pattern detection shift register
    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0;
        end else begin
            pattern_reg <= {pattern_reg[2:0], data};
        end
    end

    // Shift counter (counts 0-3 for 4 cycles)
    always @(posedge clk) begin
        if (reset || current_state != S_SHIFT) begin
            shift_counter <= 3'b0;
        end else begin
            shift_counter <= shift_counter + 1;
        end
    end

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S_IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = current_state;  // Default: stay in current state
        
        case (current_state)
            S_IDLE: 
                if (pattern_reg == 4'b1101)
                    next_state = S_SHIFT;
            
            S_SHIFT: 
                if (shift_counter == 3'd3)  // After 4 cycles (0-3)
                    next_state = S_COUNT;
            
            S_COUNT: 
                if (done_counting)
                    next_state = S_DONE;
            
            S_DONE: 
                if (ack)
                    next_state = S_IDLE;
        endcase
    end

    // Output logic - directly tied to states
    assign shift_ena = (current_state == S_SHIFT);
    assign counting = (current_state == S_COUNT);
    assign done = (current_state == S_DONE);

endmodule