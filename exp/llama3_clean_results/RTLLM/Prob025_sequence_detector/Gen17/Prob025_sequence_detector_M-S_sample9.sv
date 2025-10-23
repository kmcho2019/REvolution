module sequence_detector(
    input           clk,
    input           rst_n,
    input           data_in,
    output          sequence_detected
);

// Define the states for the finite state machine
enum logic [1:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state, next_state;

// Control logic
always_comb begin
    case (state)
        IDLE: next_state = data_in ? S1 : IDLE;
        S1: next_state = data_in ? IDLE : S2;
        S2: next_state = data_in ? IDLE : S3;
        S3: next_state = data_in ? S4 : IDLE;
        S4: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

// State register
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Output logic
assign sequence_detected = (state == S4);

endmodule