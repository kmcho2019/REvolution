module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// One-hot encoded states (5 states)
parameter [4:0] 
    IDLE = 5'b00001,
    S1   = 5'b00010,
    S2   = 5'b00100,
    S3   = 5'b01000,
    S4   = 5'b10000;

reg [4:0] current_state, next_state;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        current_state <= next_state;
        // Output is combination of state transition
        sequence_detected <= (next_state == S4);
    end
end

always @(*) begin
    next_state = IDLE;  // Default state
    case (current_state)
        IDLE: next_state = data_in ? S1 : IDLE;
        S1:   next_state = data_in ? S1 : S2;
        S2:   next_state = data_in ? S1 : S3;
        S3:   next_state = data_in ? S4 : IDLE;
        S4:   next_state = data_in ? S1 : S2;
        default: next_state = IDLE;
    endcase
end

endmodule