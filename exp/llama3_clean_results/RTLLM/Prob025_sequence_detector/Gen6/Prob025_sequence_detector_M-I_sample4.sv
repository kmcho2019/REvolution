module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output logic    sequence_detected
);

// Define the states for the sequence detection with sufficient bits to represent all states
enum logic [1:0] {
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
always_comb begin
    case (state)
        IDLE: next_state = data_in? S1 : IDLE;
        S1: next_state = ~data_in? S2 : IDLE;
        S2: next_state = ~data_in? S3 : IDLE;
        S3: next_state = data_in? S4 : IDLE;
        S4: next_state = data_in? S1 : IDLE;
        default: next_state = IDLE;
    endcase
end

// Assign the sequence_detected output
assign sequence_detected = (state == S4);

endmodule