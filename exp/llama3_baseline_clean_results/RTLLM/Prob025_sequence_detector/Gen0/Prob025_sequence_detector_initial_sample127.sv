module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define the states of the FSM
typedef enum logic [2:0] {
    IDLE = 3'b000,
    S1   = 3'b001,
    S2   = 3'b010,
    S3   = 3'b011,
    S4   = 3'b100
} state_t;

// Initialize the current state
state_t current_state;

always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        // Reset the state machine to IDLE when reset is high
        current_state <= IDLE;
        sequence_detected <= 0;
    end else begin
        case (current_state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    // Transition to S1 when the first bit of the sequence is detected
                    current_state <= S1;
                end else begin
                    // Stay in IDLE if the input is not 1
                    current_state <= IDLE;
                end
            end
            S1: begin
                if (data_in == 1'b0) begin
                    // Transition to S2 when the second bit of the sequence is detected
                    current_state <= S2;
                end else begin
                    // Reset to IDLE if the input is not 0
                    current_state <= IDLE;
                end
            end
            S2: begin
                if (data_in == 1'b0) begin
                    // Transition to S3 when the third bit of the sequence is detected
                    current_state <= S3;
                end else begin
                    // Reset to IDLE if the input is not 0
                    current_state <= IDLE;
                end
            end
            S3: begin
                if (data_in == 1'b1) begin
                    // Transition to S4 when the fourth bit of the sequence is detected
                    current_state <= S4;
                end else begin
                    // Reset to IDLE if the input is not 1
                    current_state <= IDLE;
                end
            end
            S4: begin
                // Assert sequence_detected and reset to IDLE
                sequence_detected <= 1;
                current_state <= IDLE;
            end
            default: begin
                // Stay in IDLE if the current state is unknown
                current_state <= IDLE;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (current_state == S4) begin
        // Deassert sequence_detected after one clock cycle
        sequence_detected <= 0;
    end
end

endmodule