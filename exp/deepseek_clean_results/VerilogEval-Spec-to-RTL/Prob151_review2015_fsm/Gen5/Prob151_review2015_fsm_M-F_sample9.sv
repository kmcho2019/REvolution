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
    reg [1:0] shift_counter;  // Counts 0-3 (4 cycles)
    reg [3:0] pattern_reg;

    // Pattern detection shift register (only shifts in IDLE)
    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0;
        end else if (current_state == S_IDLE) begin
            pattern_reg <= {pattern_reg[2:0], data};
        end
    end

    // Shift counter (only counts in SHIFT state)
    always @(posedge clk) begin
        if (reset || current_state != S_SHIFT) begin
            shift_counter <= 2'b0;
        end else begin
            shift_counter <= shift_counter + 1;
        end
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S_IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            S_IDLE: 
                next_state = (pattern_reg == 4'b1101) ? S_SHIFT : S_IDLE;
            
            S_SHIFT: 
                next_state = (shift_counter == 2'd3) ? S_COUNT : S_SHIFT;
            
            S_COUNT: 
                next_state = done_counting ? S_DONE : S_COUNT;
            
            S_DONE: 
                next_state = ack ? S_IDLE : S_DONE;
            
            default:
                next_state = S_IDLE;
        endcase
    end

    // Output logic - Moore style (outputs depend only on current state)
    assign shift_ena = (current_state == S_SHIFT);
    assign counting = (current_state == S_COUNT);
    assign done = (current_state == S_DONE);

endmodule