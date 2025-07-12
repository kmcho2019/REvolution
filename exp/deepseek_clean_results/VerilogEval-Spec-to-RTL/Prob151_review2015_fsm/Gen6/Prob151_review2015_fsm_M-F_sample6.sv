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

    reg [1:0] state, next_state;
    reg [1:0] shift_cnt;
    reg [3:0] pattern;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern <= 4'b0;
            shift_cnt <= 2'b0;
        end else begin
            state <= next_state;
            
            // Pattern shift only happens in IDLE state
            if (state == IDLE) begin
                pattern <= {pattern[2:0], data};
            end else begin
                pattern <= 4'b0; // Clear pattern after leaving IDLE
            end

            // Shift counter only increments in SHIFT state
            if (state == SHIFT) begin
                shift_cnt <= shift_cnt + 1;
            end else begin
                shift_cnt <= 2'b0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: 
                if (pattern == 4'b1101) 
                    next_state = SHIFT;
            SHIFT: 
                if (shift_cnt == 2'b11) 
                    next_state = COUNT;
            COUNT: 
                if (done_counting) 
                    next_state = DONE;
            DONE: 
                if (ack) 
                    next_state = IDLE;
        endcase
    end

    // Output logic
    assign shift_ena = (state == SHIFT);
    assign counting = (state == COUNT);
    assign done = (state == DONE);

endmodule