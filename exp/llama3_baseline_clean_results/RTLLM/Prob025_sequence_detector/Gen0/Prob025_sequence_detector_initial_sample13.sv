module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define the states of the finite state machine
typedef enum logic [2:0] {
    IDLE = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100
} state_t;

// Initialize the current state
state_t current_state;

// Update the current state based on the input and the current state
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        // Reset the state machine to the IDLE state when reset is high
        current_state <= IDLE;
        sequence_detected <= 0;
    end else begin
        case (current_state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    // Transition to S1 if the first bit of the sequence is detected
                    current_state <= S1;
                end else begin
                    // Stay in IDLE if the input is 0
                    current_state <= IDLE;
                end
            end
            S1: begin
                if (data_in == 1'b0) begin
                    // Transition to S2 if the second bit of the sequence is detected
                    current_state <= S2;
                end else begin
                    // Transition back to IDLE if the input is not 0
                    current_state <= IDLE;
                end
            end
            S2: begin
                if (data_in == 1'b0) begin
                    // Transition to S3 if the third bit of the sequence is detected
                    current_state <= S3;
                end else begin
                    // Transition back to IDLE if the input is not 0
                    current_state <= IDLE;
                end
            end
            S3: begin
                if (data_in == 1'b1) begin
                    // Transition to S4 if the fourth bit of the sequence is detected
                    current_state <= S4;
                end else begin
                    // Transition back to IDLE if the input is not 1
                    current_state <= IDLE;
                end
            end
            S4: begin
                // Set sequence_detected high when the sequence is detected
                sequence_detected <= 1'b1;
                // Transition back to IDLE
                current_state <= IDLE;
            end
            default: begin
                current_state <= IDLE;
            end
        endcase
    end
end

// Set sequence_detected low when the FSM is not in the S4 state
always @(current_state) begin
    if (current_state != S4) begin
        sequence_detected <= 0;
    end
end

endmodule