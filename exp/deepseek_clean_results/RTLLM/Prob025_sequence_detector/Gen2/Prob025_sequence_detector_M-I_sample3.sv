module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// State definitions
typedef enum logic [4:0] {
    IDLE = 5'b00001,
    S1   = 5'b00010,
    S2   = 5'b00100,
    S3   = 5'b01000,
    S4   = 5'b10000
} state_t;

// State registers
state_t current_state, next_state;

// State transition logic
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE: next_state = (data_in == 1'b1) ? S1 : IDLE;
        S1:   next_state = (data_in == 1'b0) ? S2 : S1;
        S2:   next_state = (data_in == 1'b0) ? S3 : S1;
        S3:   next_state = (data_in == 1'b1) ? S4 : IDLE;
        S4:   next_state = (data_in == 1'b1) ? S1 : S2;
        default: next_state = IDLE;
    endcase
end

// Output logic (Moore machine: output depends only on current state)
always @(*) begin
    sequence_detected = (current_state == S4);
end

endmodule