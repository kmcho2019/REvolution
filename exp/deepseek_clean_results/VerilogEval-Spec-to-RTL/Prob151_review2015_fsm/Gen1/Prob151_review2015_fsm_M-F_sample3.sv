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
        COUNT,
        DONE
    } state_t;

    reg [1:0] state, next_state;
    reg [1:0] shift_counter;
    reg [3:0] pattern_reg;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            shift_counter <= 2'b0;
        end else begin
            state <= next_state;
            
            // Only shift in data for pattern detection during IDLE
            if (state == IDLE) begin
                pattern_reg <= {pattern_reg[2:0], data};
            end
            
            // Count shift cycles
            if (state == SHIFT) begin
                shift_counter <= shift_counter + 1;
            end else begin
                shift_counter <= 2'b0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // Default to stay in current state
        
        case (state)
            IDLE: begin
                if (pattern_reg == 4'b1101) begin
                    next_state = SHIFT;
                end
            end
            
            SHIFT: begin
                if (shift_counter == 2'd3) begin
                    next_state = COUNT;
                end
            end
            
            COUNT: begin
                if (done_counting) begin
                    next_state = DONE;
                end
            end
            
            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    // Output logic
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting = (state == COUNT);
        done = (state == DONE);
    end

endmodule