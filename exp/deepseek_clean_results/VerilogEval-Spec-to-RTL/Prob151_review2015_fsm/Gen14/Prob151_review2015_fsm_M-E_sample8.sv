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
        SHIFT_DURATION,
        WAIT_COUNT,
        NOTIFY
    } state_t;

    state_t current_state, next_state;
    reg [3:0] pattern_reg;
    reg [1:0] shift_counter;
    reg pattern_matched;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            pattern_reg <= 4'b0;
            shift_counter <= 2'b0;
            pattern_matched <= 1'b0;
        end else begin
            current_state <= next_state;

            // Pattern detection in IDLE state
            if (current_state == IDLE) begin
                pattern_reg <= {pattern_reg[2:0], data};
                if (pattern_reg == 4'b1101) begin
                    pattern_matched <= 1'b1;
                end else if (pattern_reg[2:0] == 3'b110 && !data) begin
                    pattern_matched <= 1'b0;  // Early reset on pattern mismatch
                end
            end

            // Shift counter in SHIFT_DURATION state
            if (current_state == SHIFT_DURATION) begin
                shift_counter <= shift_counter + 1;
            end else begin
                shift_counter <= 2'b0;
            end
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            IDLE: 
                next_state = pattern_matched ? SHIFT_DURATION : IDLE;
            
            SHIFT_DURATION:
                next_state = (shift_counter == 2'b11) ? WAIT_COUNT : SHIFT_DURATION;
            
            WAIT_COUNT:
                next_state = done_counting ? NOTIFY : WAIT_COUNT;
            
            NOTIFY:
                next_state = ack ? IDLE : NOTIFY;
            
            default:
                next_state = IDLE;
        endcase
    end

    // Output logic
    assign shift_ena = (current_state == SHIFT_DURATION);
    assign counting = (current_state == WAIT_COUNT);
    assign done = (current_state == NOTIFY);

endmodule