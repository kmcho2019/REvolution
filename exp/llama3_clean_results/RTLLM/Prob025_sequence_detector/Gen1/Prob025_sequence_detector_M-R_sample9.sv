module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output          sequence_detected
);

// Define the states of the FSM
logic [2:0] current_state;

// Reset the state machine to IDLE when reset_n is low
always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= 3'b000; // IDLE
    end else begin
        case (current_state)
            3'b000: // IDLE
                current_state <= data_in ? 3'b001 : 3'b000; // Transition to S1 if data_in is 1, else stay in IDLE
            3'b001: // S1
                current_state <= data_in ? 3'b001 : 3'b010; // Transition to S2 if data_in is 0, else stay in S1
            3'b010: // S2
                current_state <= data_in ? 3'b011 : 3'b000; // Transition to S3 if data_in is 1, else go back to IDLE
            3'b011: // S3
                current_state <= data_in ? 3'b100 : 3'b000; // Transition to S4 if data_in is 1, else go back to IDLE
            3'b100: // S4
                current_state <= 3'b000; // Go back to IDLE after detecting the sequence
            default:
                current_state <= 3'b000; // Default to IDLE for any other state
        endcase
    end
end

// Directly assign sequence_detected based on the current state
assign sequence_detected = (current_state == 3'b100); // 1 when in state S4, 0 otherwise

endmodule