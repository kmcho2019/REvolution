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
        IDLE,
        SHIFT,
        COUNT,
        DONE
    } state_t;

    state_t current_state, next_state;

    // Pattern detection registers
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
            
            // Always shift in new data
            pattern_reg <= {pattern_reg[2:0], data};

            // Counter control
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
                next_state = (pattern_reg == 4'b1101) ? SHIFT : IDLE;
            end
            
            SHIFT: begin
                next_state = (shift_counter == 2'b11) ? COUNT : SHIFT;
            end
            
            COUNT: begin
                next_state = done_counting ? DONE : COUNT;
            end
            
            DONE: begin
                next_state = ack ? IDLE : DONE;
            end
            
            default: next_state = IDLE;
        endcase
    end

    // Output assignments
    assign shift_ena = (current_state == SHIFT);
    assign counting = (current_state == COUNT);
    assign done = (current_state == DONE);

endmodule