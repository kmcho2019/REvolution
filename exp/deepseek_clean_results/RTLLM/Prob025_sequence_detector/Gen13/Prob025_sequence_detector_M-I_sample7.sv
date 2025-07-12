module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// State encoding using one-hot for better synthesis optimization
typedef enum logic [3:0] {
    IDLE = 4'b0001,
    S1   = 4'b0010,  // '1' received
    S2   = 4'b0100,  // '10' received
    S3   = 4'b1000,  // '100' received
    S4   = 4'b0000   // '1001' received (output asserted)
} state_t;

reg [3:0] current_state, next_state;

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

// State register and output logic
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end
    else begin
        current_state <= next_state;
        // Register output to break critical path
        sequence_detected <= (next_state == S4);
    end
end

endmodule