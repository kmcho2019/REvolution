module sequence_detector(
    input           clk,
    input           reset_n, // Ensure consistent naming
    input           data_in,
    output          sequence_detected
);

// Define the states of the finite state machine
typedef enum logic [2:0] {
    IDLE = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100
} state_t;

// Current state and next state
state_t current_state, next_state;

// Control logic
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic simplified
always @(*) begin
    case (current_state)
        IDLE: next_state = (data_in == 1'b1) ? S1 : IDLE;
        S1: next_state = (data_in == 1'b0) ? S2 : IDLE;
        S2: next_state = (data_in == 1'b0) ? S3 : IDLE;
        S3: next_state = (data_in == 1'b1) ? S4 : IDLE;
        S4: next_state = IDLE; // Reset to IDLE after detection
        default: next_state = IDLE;
    endcase
end

// Output logic remains straightforward
assign sequence_detected = (current_state == S4);

endmodule