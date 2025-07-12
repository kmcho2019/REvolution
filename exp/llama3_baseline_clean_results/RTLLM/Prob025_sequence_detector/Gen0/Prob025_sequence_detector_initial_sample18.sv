module sequence_detector(
    input clk, 
    input reset_n, 
    input data_in, 
    output reg sequence_detected
);

// Define the states for the FSM
typedef enum logic [2:0] {
    IDLE = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100
} state_t;

// Initialize the current state
reg [2:0] current_state;

// Initialize the sequence detected signal
initial sequence_detected = 1'b0;

// Always block for FSM state transitions and output logic
always @ (posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        // Reset the state machine to IDLE state when reset is high
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        case (current_state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    // Transition to S1 state when the first bit of the sequence is detected
                    current_state <= S1;
                end else begin
                    // Stay in IDLE state if the input bit does not match the sequence
                    current_state <= IDLE;
                end
            end
            S1: begin
                if (data_in == 1'b0) begin
                    // Transition to S2 state when the second bit of the sequence is detected
                    current_state <= S2;
                end else begin
                    // Transition back to IDLE state if the input bit does not match the sequence
                    current_state <= IDLE;
                end
            end
            S2: begin
                if (data_in == 1'b0) begin
                    // Transition to S3 state when the third bit of the sequence is detected
                    current_state <= S3;
                end else begin
                    // Transition back to IDLE state if the input bit does not match the sequence
                    current_state <= IDLE;
                end
            end
            S3: begin
                if (data_in == 1'b1) begin
                    // Transition to S4 state when the fourth bit of the sequence is detected
                    current_state <= S4;
                end else begin
                    // Transition back to IDLE state if the input bit does not match the sequence
                    current_state <= IDLE;
                end
            end
            S4: begin
                // Assert the sequence_detected signal when the complete sequence is detected
                sequence_detected <= 1'b1;
                // Transition back to IDLE state after detecting the sequence
                current_state <= IDLE;
            end
            default: begin
                // Default state is IDLE
                current_state <= IDLE;
            end
        endcase
    end
end

// Assert the sequence_detected signal for one clock cycle when the sequence is detected
always @ (posedge clk) begin
    if (current_state == S4) begin
        sequence_detected <= 1'b1;
    end else begin
        sequence_detected <= 1'b0;
    end
end

endmodule