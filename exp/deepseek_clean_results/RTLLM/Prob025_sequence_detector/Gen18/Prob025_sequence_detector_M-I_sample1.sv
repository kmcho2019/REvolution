module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// State encoding
typedef enum logic [2:0] {
    IDLE = 3'b000,
    S1   = 3'b001,  // 1
    S2   = 3'b010,  // 10
    S3   = 3'b011,  // 100
    S4   = 3'b100   // 1001 (output asserted)
} state_t;

reg [2:0] current_state, next_state;

// State transition logic
always @(*) begin
    case (current_state)
        IDLE: next_state = data_in ? S1 : IDLE;
        S1:   next_state = data_in ? S1 : S2;
        S2:   next_state = data_in ? S3 : IDLE;
        S3:   next_state = data_in ? S4 : S2;
        S4:   next_state = data_in ? S1 : IDLE;
        default: next_state = IDLE;
    endcase
end

// State register and output logic
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end
    else begin
        current_state <= next_state;
        // Registered output improves timing
        sequence_detected <= (next_state == S4);
    end
end

endmodule