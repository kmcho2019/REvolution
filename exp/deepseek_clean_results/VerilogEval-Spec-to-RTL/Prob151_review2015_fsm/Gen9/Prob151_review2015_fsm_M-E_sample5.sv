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

    // State encoding
    typedef enum logic [1:0] {
        IDLE,
        SHIFT_DURATION,
        COUNTING_STATE,
        DONE_STATE
    } state_t;

    state_t current_state, next_state;

    // Pattern detection registers
    reg [3:0] pattern_shift_reg;
    reg pattern_found;

    // Shift counter
    reg [1:0] shift_counter;

    // Continuous pattern detection
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift_reg <= 4'b0;
            pattern_found <= 1'b0;
        end else begin
            pattern_shift_reg <= {pattern_shift_reg[2:0], data};
            pattern_found <= (pattern_shift_reg == 4'b1101);
        end
    end

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            shift_counter <= 2'b0;
        end else begin
            current_state <= next_state;
            
            if (current_state == SHIFT_DURATION) begin
                shift_counter <= shift_counter + 1'b1;
            end else begin
                shift_counter <= 2'b0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                next_state = pattern_found ? SHIFT_DURATION : IDLE;
            end
            
            SHIFT_DURATION: begin
                if (shift_counter == 2'b11) begin
                    next_state = COUNTING_STATE;
                end else begin
                    next_state = SHIFT_DURATION;
                end
            end
            
            COUNTING_STATE: begin
                next_state = done_counting ? DONE_STATE : COUNTING_STATE;
            end
            
            DONE_STATE: begin
                next_state = ack ? IDLE : DONE_STATE;
            end
            
            default: next_state = IDLE;
        endcase
    end

    // Registered output generation
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            shift_ena <= (current_state == SHIFT_DURATION);
            counting <= (current_state == COUNTING_STATE);
            done <= (current_state == DONE_STATE);
        end
    end

endmodule