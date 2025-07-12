// Sequence Detector Module
module sequence_detector (
    input           clk,        // Clock signal
    input           reset_n,    // Reset signal (active low)
    input           data_in,    // 1-bit binary input signal
    output          sequence_detected  // 1-bit output signal
);

// Define the states
parameter   IDLE = 4'b0000,    // Waiting for the start of the sequence
            S1   = 4'b0001,    // The first bit of the desired sequence is detected
            S2   = 4'b0010,    // The second bit of the desired sequence is detected
            S3   = 4'b0011,    // The third bit of the desired sequence is detected
            S4   = 4'b0100;    // The fourth and final bit of the desired sequence is detected

// Define the sequence to be detected
parameter   SEQUENCE = 4'b1001;

// Internal state register
reg [3:0]   current_state;

// Initialize the state machine
initial current_state = IDLE;

// State machine logic
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        // Reset the state machine to the IDLE state
        current_state <= IDLE;
    end else begin
        case (current_state)
            IDLE: begin
                if (data_in == SEQUENCE[3]) begin
                    // Transition to S1 if the first bit matches
                    current_state <= S1;
                end else begin
                    // Stay in IDLE if the first bit does not match
                    current_state <= IDLE;
                end
            end
            S1: begin
                if (data_in == SEQUENCE[2]) begin
                    // Transition to S2 if the second bit matches
                    current_state <= S2;
                end else begin
                    // Reset to IDLE if the second bit does not match
                    current_state <= IDLE;
                end
            end
            S2: begin
                if (data_in == SEQUENCE[1]) begin
                    // Transition to S3 if the third bit matches
                    current_state <= S3;
                end else begin
                    // Reset to IDLE if the third bit does not match
                    current_state <= IDLE;
                end
            end
            S3: begin
                if (data_in == SEQUENCE[0]) begin
                    // Transition to S4 if the fourth bit matches
                    current_state <= S4;
                end else begin
                    // Reset to IDLE if the fourth bit does not match
                    current_state <= IDLE;
                end
            end
            S4: begin
                // Stay in S4 and assert sequence_detected
                current_state <= IDLE;  // Reset to IDLE after detection
            end
            default: begin
                // Default to IDLE if an invalid state is reached
                current_state <= IDLE;
            end
        endcase
    end
end

// Output logic
assign sequence_detected = (current_state == S4);

endmodule