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

    // Main state encoding with sufficient bits
    typedef enum logic [2:0] {
        S_IDLE,
        S_SHIFT_START,
        S_SHIFT_ACTIVE,
        S_COUNT_WAIT,
        S_DONE_ACTIVE,
        S_DONE_RELEASE
    } state_t;

    reg [2:0] current_state, next_state;
    reg [1:0] shift_counter;
    reg [3:0] pattern_detect;

    // Pattern detection shift register
    always @(posedge clk) begin
        if (reset) begin
            pattern_detect <= 4'b0;
        end else begin
            pattern_detect <= {pattern_detect[2:0], data};
        end
    end

    // Shift counter control
    always @(posedge clk) begin
        if (reset || current_state != S_SHIFT_ACTIVE) begin
            shift_counter <= 2'b0;
        end else begin
            shift_counter <= shift_counter + 1;
        end
    end

    // State transition logic
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
            S_IDLE: begin
                next_state = (pattern_detect == 4'b1101) ? S_SHIFT_START : S_IDLE;
            end
            
            S_SHIFT_START: begin
                next_state = S_SHIFT_ACTIVE;
            end
            
            S_SHIFT_ACTIVE: begin
                next_state = (shift_counter == 2'b11) ? S_COUNT_WAIT : S_SHIFT_ACTIVE;
            end
            
            S_COUNT_WAIT: begin
                next_state = done_counting ? S_DONE_ACTIVE : S_COUNT_WAIT;
            end
            
            S_DONE_ACTIVE: begin
                next_state = ack ? S_DONE_RELEASE : S_DONE_ACTIVE;
            end
            
            S_DONE_RELEASE: begin
                next_state = S_IDLE;
            end
            
            default: next_state = S_IDLE;
        endcase
    end

    // Output logic - combinatorial
    assign shift_ena = (current_state == S_SHIFT_ACTIVE);
    assign counting = (current_state == S_COUNT_WAIT);
    assign done = (current_state == S_DONE_ACTIVE) || (current_state == S_DONE_RELEASE);

endmodule