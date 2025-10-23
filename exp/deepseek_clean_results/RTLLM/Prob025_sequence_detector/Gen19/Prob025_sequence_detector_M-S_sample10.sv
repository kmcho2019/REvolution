module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// State encoding
typedef enum logic [2:0] {
    IDLE = 3'b000,
    S1   = 3'b001,  // '1' detected
    S2   = 3'b010,  // '10' detected
    S3   = 3'b011,  // '100' detected
    S4   = 3'b100   // '1001' detected
} state_t;

state_t current_state, next_state;

// State transition logic
always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE: next_state = data_in ? S1 : IDLE;
        S1:   next_state = data_in ? S1 : S2;
        S2:   next_state = data_in ? S1 : S3;
        S3:   next_state = data_in ? S4 : IDLE;
        S4:   next_state = data_in ? S1 : S2;
        default: next_state = IDLE;
    endcase
end

// Output logic
assign sequence_detected = (current_state == S4);

endmodule