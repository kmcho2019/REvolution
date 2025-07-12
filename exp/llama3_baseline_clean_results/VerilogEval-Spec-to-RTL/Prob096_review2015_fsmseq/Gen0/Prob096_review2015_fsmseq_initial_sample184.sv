module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Enumerating states for readability
typedef enum {
    IDLE,
    FIRST_ONE,
    SECOND_ONE,
    AFTER_ZERO,
    SEQUENCE_DETECTED
} state_type;

state_type current_state, next_state;

always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
        start_shifting <= 0;
    end else begin
        current_state <= next_state;
        if (current_state == SEQUENCE_DETECTED) begin
            start_shifting <= 1;
        end
    end
end

always @(*) begin
    case (current_state)
        IDLE: begin
            if (data) begin
                next_state = FIRST_ONE;
            end else begin
                next_state = IDLE;
            end
        end
        FIRST_ONE: begin
            if (data) begin
                next_state = SECOND_ONE;
            end else begin
                next_state = IDLE; // Reset sequence if '0' is seen
            end
        end
        SECOND_ONE: begin
            if (~data) begin
                next_state = AFTER_ZERO;
            end else begin
                next_state = FIRST_ONE; // Incorrect sequence, backtrack
            end
        end
        AFTER_ZERO: begin
            if (data) begin
                next_state = SEQUENCE_DETECTED;
            end else begin
                next_state = IDLE; // Sequence failed, reset
            end
        end
        SEQUENCE_DETECTED: begin
            next_state = SEQUENCE_DETECTED; // Stay in this state
        end
    endcase
end

endmodule