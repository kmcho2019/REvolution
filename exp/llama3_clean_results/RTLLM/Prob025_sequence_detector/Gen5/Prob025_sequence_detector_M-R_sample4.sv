module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output          sequence_detected
);

// Define the states for the sequence detection with sufficient bits to represent all states
enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state, next_state;

// Update the state
always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Determine the next state using assign statements
assign next_state = (state == IDLE && data_in) ? S1 :
                    (state == S1 && ~data_in) ? S2 :
                    (state == S2 && ~data_in) ? S3 :
                    (state == S3 && data_in) ? S4 :
                    (state == S4) ? S1 :
                    IDLE;

// Assign the sequence_detected output
assign sequence_detected = (state == S4);

endmodule