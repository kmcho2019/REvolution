module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// State definitions
typedef enum logic [2:0] {
    IDLE,
    S1,     // 1
    S2,      // 10
    S3,      // 100
    S4       // 1001
} state_t;

state_t current_state, next_state;

// State transition logic
always_comb begin
    case (current_state)
        IDLE: next_state = data_in ? S1 : IDLE;
        S1:   next_state = data_in ? S1 : S2;
        S2:   next_state = data_in ? S1 : S3;
        S3:   next_state = data_in ? S4 : IDLE;
        S4:   next_state = data_in ? S1 : S2;
        default: next_state = IDLE;
    endcase
end

// State register and output logic
always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        current_state <= next_state;
        // Detect when we reach S4 state
        sequence_detected <= (next_state == S4);
    end
end

endmodule