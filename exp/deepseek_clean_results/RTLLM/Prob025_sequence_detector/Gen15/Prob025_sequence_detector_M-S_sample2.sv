module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

typedef enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state_t;

state_t current_state, next_state;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    sequence_detected = 1'b0;
    next_state = current_state;
    
    case (current_state)
        IDLE: if (data_in) next_state = S1;
        S1:   next_state = data_in ? S1 : S2;
        S2:   next_state = data_in ? S1 : S3;
        S3:   if (data_in) begin
                  next_state = S4;
                  sequence_detected = 1'b1;
              end else begin
                  next_state = IDLE;
              end
        S4:   next_state = data_in ? S1 : S2;
        default: next_state = IDLE;
    endcase
end

endmodule