module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// Define states
typedef enum logic [1:0] {
    IDLE,
    S1,     // Received '1'
    S2,     // Received '10'
    S3      // Received '100'
} state_t;

state_t current_state, next_state;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end
    else begin
        current_state <= next_state;
        // Output is high only when we detect the full sequence
        sequence_detected <= (current_state == S3) && (data_in == 1'b1);
    end
end

// Next state logic with early termination
always @(*) begin
    case (current_state)
        IDLE: next_state = (data_in == 1'b1) ? S1 : IDLE;
        S1:   next_state = (data_in == 1'b0) ? S2 : S1;
        S2:   next_state = (data_in == 1'b0) ? S3 : IDLE;
        S3:   next_state = (data_in == 1'b1) ? S1 : IDLE;
        default: next_state = IDLE;
    endcase
end

// Power gating control (conceptual - implementation depends on technology)
wire comparison_enable = (current_state != IDLE);
// In actual implementation, this would control power gates for comparison logic

endmodule