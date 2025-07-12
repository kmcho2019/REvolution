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

    // State definitions
    typedef enum logic [2:0] {
        IDLE,
        SHIFT_DURATION,
        WAIT_COUNT,
        NOTIFY_DONE
    } state_t;

    state_t current_state, next_state;

    // Pattern detection shift register
    reg [3:0] data_shift;
    wire pattern_match = (data_shift == 4'b1101);

    // Shift counter (counts 0-3 for 4 cycles)
    reg [1:0] shift_counter;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            data_shift <= 4'b0;
            shift_counter <= 2'b0;
        end else begin
            current_state <= next_state;
            
            // Always shift in new data
            data_shift <= {data_shift[2:0], data};
            
            // Counter only increments during shift phase
            if (current_state == SHIFT_DURATION) begin
                shift_counter <= shift_counter + 1;
            end else begin
                shift_counter <= 2'b0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE: 
                if (pattern_match) 
                    next_state = SHIFT_DURATION;
            
            SHIFT_DURATION:
                if (shift_counter == 2'b11) // After 4 cycles (0-3)
                    next_state = WAIT_COUNT;
            
            WAIT_COUNT:
                if (done_counting) 
                    next_state = NOTIFY_DONE;
            
            NOTIFY_DONE:
                if (ack) 
                    next_state = IDLE;
        endcase
    end

    // Output logic - purely combinational
    assign shift_ena = (current_state == SHIFT_DURATION);
    assign counting = (current_state == WAIT_COUNT);
    assign done = (current_state == NOTIFY_DONE);

endmodule