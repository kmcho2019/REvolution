module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define the states of the FSM
enum logic [1:0] {
    IDLE = 2'b00,
    S1 = 2'b01,
    S2 = 2'b10,
    S3 = 2'b11
} state, next_state;

// State machine logic
always_comb begin
    case (state)
        IDLE: next_state = (data_in == 1'b1)? S1 : IDLE;
        S1: next_state = (data_in == 1'b0)? S2 : IDLE;
        S2: next_state = (data_in == 1'b0)? S3 : IDLE;
        S3: next_state = (data_in == 1'b1)? S3 : IDLE;
        default: next_state = IDLE;
    endcase
end

// State machine update
always_ff @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Sequence detection
always_comb begin
    if (state == S3 && data_in == 1'b1) begin
        sequence_detected = 1'b1;
    end else begin
        sequence_detected = 1'b0;
    end
end

endmodule