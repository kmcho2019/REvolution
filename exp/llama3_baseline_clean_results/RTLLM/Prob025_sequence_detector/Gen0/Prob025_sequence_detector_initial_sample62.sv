module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Enumerate the states of the FSM
enum logic [2:0] {
    IDLE = 3'b001,
    S1 = 3'b010,
    S2 = 3'b011,
    S3 = 3'b100,
    S4 = 3'b101
} state, next_state;

// Sequence detection logic
always @(*) begin
    case (state)
        IDLE: next_state = (data_in == 1'b1) ? S1 : IDLE;
        S1: next_state = (data_in == 1'b0) ? S2 : IDLE;
        S2: next_state = (data_in == 1'b0) ? S2 : S3;
        S3: next_state = (data_in == 1'b1) ? S4 : IDLE;
        S4: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

// Update state on clock edge and reset
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        state <= next_state;
        sequence_detected <= (state == S4) ? 1'b1 : 1'b0;
    end
end

endmodule