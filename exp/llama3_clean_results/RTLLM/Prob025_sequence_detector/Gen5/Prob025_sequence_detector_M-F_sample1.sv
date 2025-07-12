module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output reg      sequence_detected
);

// Define the states of the finite state machine
typedef enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state_t;

// Initialize the current state
state_t current_state;

// Always block to handle state transitions and output
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        // Reset the state machine to IDLE when reset_n is low
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        case (current_state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    // Transition to S1 if the input is 1
                    current_state <= S1;
                end else begin
                    // Stay in IDLE if the input is 0
                    current_state <= IDLE;
                end
            end
            S1: begin
                if (data_in == 1'b0) begin
                    // Transition to S2 if the input is 0
                    current_state <= S2;
                end else begin
                    // Return to IDLE if the input is 1
                    current_state <= IDLE;
                end
            end
            S2: begin
                if (data_in == 1'b0) begin
                    // Transition to S3 if the input is 0
                    current_state <= S3;
                end else begin
                    // Return to IDLE if the input is 1
                    current_state <= IDLE;
                end
            end
            S3: begin
                if (data_in == 1'b1) begin
                    // Transition to S4 if the input is 1
                    current_state <= S4;
                end else begin
                    // Return to IDLE if the input is 0
                    current_state <= IDLE;
                end
            end
            S4: begin
                // Assert sequence_detected and return to IDLE
                sequence_detected <= 1'b1;
                current_state <= IDLE;
            end
            default: begin
                // Default case to handle any unexpected states
                current_state <= IDLE;
            end
        endcase
        // Deassert sequence_detected in all states except S4
        if (current_state != S4) begin
            sequence_detected <= 1'b0;
        end
    end
end

endmodule