module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define states
enum logic [2:0] {IDLE, S1, S2, S3, S4} state, next_state;

// State machine
always @(*) begin
    case(state)
        IDLE: next_state = (data_in == 1'b1) ? S1 : IDLE;
        S1: next_state = (data_in == 1'b0) ? S2 : IDLE;
        S2: next_state = (data_in == 1'b0) ? S3 : IDLE;
        S3: next_state = (data_in == 1'b1) ? S4 : IDLE;
        S4: next_state = IDLE; // Reset to IDLE after sequence detected
        default: next_state = IDLE;
    endcase
end

// State register
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