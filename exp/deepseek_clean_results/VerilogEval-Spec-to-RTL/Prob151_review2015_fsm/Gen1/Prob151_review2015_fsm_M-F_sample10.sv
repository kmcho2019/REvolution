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
    reg [3:0] pattern_buffer;

    // State transition and sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_buffer <= 4'b0;
            shift_counter <= 2'b0;
        end else begin
            state <= next_state;
            
            // Shift in new data bit
            pattern_buffer <= {pattern_buffer[2:0], data};
            
            // Counter for SHIFT state
            if (state == SHIFT)
                shift_counter <= shift_counter + 1;
            else
                shift_counter <= 2'b0;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (pattern_buffer == 4'b1101)
                    next_state = SHIFT;
                else
                    next_state = IDLE;
            end
            SHIFT: begin
                if (shift_counter == 2'd3)  // After 4 cycles (0-3)
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end
            COUNT: begin
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end
            DONE: begin
                if (ack)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic - strictly tied to states
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting = (state == COUNT);
        done = (state == DONE);
    end

endmodule