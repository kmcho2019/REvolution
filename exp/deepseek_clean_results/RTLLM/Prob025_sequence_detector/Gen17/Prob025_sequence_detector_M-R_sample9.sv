module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// State encoding
typedef enum logic [2:0] {
    IDLE = 3'b000,
    S1   = 3'b001,
    S2   = 3'b010,
    S3   = 3'b011,
    S4   = 3'b100
} state_t;

reg [2:0] current_state, next_state;

// State transition logic
always @(*) begin
    case (current_state)
        IDLE: next_state = data_in ? S1 : IDLE;
        S1:   next_state = data_in ? S1 : S2;
        S2:   next_state = data_in ? S3 : IDLE;
        S3:   next_state = data_in ? S1 : S4;
        S4:   next_state = data_in ? S1 : IDLE;
        default: next_state = IDLE;
    endcase
end

// State register
always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

// Mealy output - depends on current state and input
assign sequence_detected = (current_state == S3) && !data_in;

endmodule