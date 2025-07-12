module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output          sequence_detected
);

// Define the states for the sequence detection
typedef enum logic [2:0] {
    IDLE = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100
} state_t;

state_t state, next_state;

// Update the state
always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Determine the next state using direct conditional assignments
always_comb begin
    next_state = state;
    case (state)
        IDLE: if (data_in == 1'b1) next_state = S1;
        S1: if (data_in == 1'b0) next_state = S2; else next_state = IDLE;
        S2: if (data_in == 1'b0) next_state = S3; else next_state = IDLE;
        S3: if (data_in == 1'b1) next_state = S4; else next_state = IDLE;
        S4: next_state = IDLE; // Reset to IDLE after detecting the sequence
        default: next_state = IDLE;
    endcase
end

// Assign the sequence_detected output directly based on state
assign sequence_detected = (state == S4);

endmodule