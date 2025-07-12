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
    reg [2:0] shift_counter;
    reg [3:0] pattern_reg;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            shift_counter <= 3'b0;
        end else begin
            state <= next_state;
            
            // Shift in data for pattern detection
            pattern_reg <= {pattern_reg[2:0], data};
            
            // Count shift cycles
            if (state == SHIFT) begin
                shift_counter <= shift_counter + 1;
            end else begin
                shift_counter <= 3'b0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (pattern_reg == 4'b1101) begin
                    next_state = SHIFT;
                end else begin
                    next_state = IDLE;
                end
            end
            
            SHIFT: begin
                if (shift_counter == 3'd3) begin
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
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting = (state == COUNT);
        done = (state == DONE);
    end

endmodule