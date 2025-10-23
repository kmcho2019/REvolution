module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// Enumerate the states of the state machine
typedef enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state_t;

// Declare the current and next states
state_t current_state, next_state;

// Assign the output sequence_detected based on the current state
assign sequence_detected = (current_state == S4) ? 1'b1 : 1'b0;

// Always block to handle the clock and reset signals
always_ff @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        // Reset the state machine to the IDLE state
        current_state <= IDLE;
    end else begin
        // Transition to the next state
        current_state <= next_state;
    end
end

// Always block to handle the state machine logic
always_comb begin
    case (current_state)
        IDLE: begin
            if (data_in == 1'b1) begin
                // Transition to S1 if the input is 1
                next_state = S1;
            end else begin
                // Stay in IDLE if the input is 0
                next_state = IDLE;
            end
        end
        S1: begin
            if (data_in == 1'b0) begin
                // Transition to S2 if the input is 0
                next_state = S2;
            end else begin
                // Stay in S1 if the input is 1
                next_state = IDLE;  // Reset to IDLE for incorrect sequence
            end
        end
        S2: begin
            if (data_in == 1'b0) begin
                // Transition to S3 if the input is 0
                next_state = S3;
            end else begin
                // Stay in S2 if the input is 1
                next_state = IDLE;  // Reset to IDLE for incorrect sequence
            end
        end
        S3: begin
            if (data_in == 1'b1) begin
                // Transition to S4 if the input is 1
                next_state = S4;
            end else begin
                // Stay in S3 if the input is 0
                next_state = IDLE;  // Reset to IDLE for incorrect sequence
            end
        end
        S4: begin
            // Stay in S4
            next_state = IDLE;  // Reset to IDLE after sequence detection
        end
        default: begin
            // Default state
            next_state = IDLE;
        end
    endcase
end

endmodule