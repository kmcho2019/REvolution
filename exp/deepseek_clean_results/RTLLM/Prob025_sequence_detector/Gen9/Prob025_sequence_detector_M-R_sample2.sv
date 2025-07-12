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

// State transition logic
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state and output logic
always @(*) begin
    sequence_detected = 1'b0;
    case (current_state)
        IDLE: next_state = data_in ? S1 : IDLE;
        S1:   next_state = data_in ? S1 : S2;
        S2:   next_state = data_in ? S1 : S3;
        S3:   begin
            if (data_in) begin
                next_state = S4;
                sequence_detected = 1'b1;  // Mealy output
            end else begin
                next_state = IDLE;
            end
        end
        S4:   next_state = data_in ? S1 : S2;  // Handle overlapping sequences
        default: next_state = IDLE;
    endcase
end

endmodule