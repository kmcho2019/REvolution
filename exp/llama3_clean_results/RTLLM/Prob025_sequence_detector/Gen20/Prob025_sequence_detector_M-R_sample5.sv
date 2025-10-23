module sequence_detector(
    input           clk,
    input           rst_n,
    input           data_in,
    output          sequence_detected
);

// Define the states for the finite state machine
enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state, next_state;

// Control logic
assign next_state = (state == IDLE && data_in == 1'b1) ? S1 :
                    (state == S1 && data_in == 1'b0) ? S2 :
                    (state == S2 && data_in == 1'b0) ? S3 :
                    (state == S3 && data_in == 1'b1) ? S4 :
                    (state == S4) ? IDLE : IDLE;

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