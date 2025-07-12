module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// FSM states
typedef enum logic [2:0] {
    IDLE,
    S1,     // 1
    S2,     // 10
    S3,     // 100
    S4      // 1001
} state_t;

state_t current_state, next_state;

// State transition logic
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    sequence_detected <= (next_state == S4);
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE: next_state = data_in ? S1 : IDLE;
        S1:    next_state = data_in ? S1 : S2;
        S2:    next_state = data_in ? S1 : S3;
        S3:    next_state = data_in ? S4 : IDLE;
        S4:    next_state = data_in ? S1 : S2;
        default: next_state = IDLE;
    endcase
end

endmodule