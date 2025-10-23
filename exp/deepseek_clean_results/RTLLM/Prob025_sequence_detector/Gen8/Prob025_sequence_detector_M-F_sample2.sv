module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// State encoding
typedef enum logic [2:0] {
    IDLE = 3'b000,
    S1   = 3'b001,
    S2   = 3'b010,
    S3   = 3'b011,
    S4   = 3'b100
} state_t;

state_t current_state, next_state;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end
    else begin
        current_state <= next_state;
        // Output is high only when we reach S4 with correct final bit
        sequence_detected <= (next_state == S4);
    end
end

always @(*) begin
    case (current_state)
        IDLE: next_state = (data_in == 1'b1) ? S1 : IDLE;
        S1:   next_state = (data_in == 1'b0) ? S2 : S1;
        S2:   next_state = (data_in == 1'b0) ? S3 : S1;
        S3:   next_state = (data_in == 1'b1) ? S4 : IDLE;
        S4:   next_state = (data_in == 1'b1) ? S1 : IDLE;
        default: next_state = IDLE;
    endcase
end

endmodule