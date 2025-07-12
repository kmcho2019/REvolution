module sequence_detector(
    input        clk,        // Clock signal
    input        reset_n,    // Reset signal
    input        data_in,    // 1-bit binary input signal
    output reg   sequence_detected  // 1-bit output signal
);

// Define the states of the FSM
parameter   IDLE = 4'd0,  // Waiting for the start of the sequence
            S1   = 4'd1,  // The first bit of the desired sequence is detected
            S2   = 4'd2,  // The second bit of the desired sequence is detected
            S3   = 4'd3,  // The third bit of the desired sequence is detected
            S4   = 4'd4;  // The fourth and final bit of the desired sequence is detected

reg [3:0]   current_state;  // Current state of the FSM
reg [3:0]   next_state;      // Next state of the FSM

// State transition logic
always @(*) begin
    case (current_state)
        IDLE: begin
            if (data_in == 1'b1)  // If the input data is 1, transition to S1
                next_state = S1;
            else
                next_state = IDLE;  // Otherwise, stay in IDLE
        end
        S1: begin
            if (data_in == 1'b0)  // If the input data is 0, transition to S2
                next_state = S2;
            else
                next_state = S1;  // Otherwise, stay in S1
        end
        S2: begin
            if (data_in == 1'b0)  // If the input data is 0, transition to S3
                next_state = S3;
            else
                next_state = IDLE;  // Otherwise, return to IDLE
        end
        S3: begin
            if (data_in == 1'b1)  // If the input data is 1, transition to S4
                next_state = S4;
            else
                next_state = IDLE;  // Otherwise, return to IDLE
        end
        S4: begin
            next_state = IDLE;  // Return to IDLE after detecting the sequence
        end
        default: begin
            next_state = IDLE;  // Default to IDLE if the current state is unknown
        end
    endcase
end

// State register
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;  // Reset the FSM to IDLE
        sequence_detected <= 1'b0;  // Reset the sequence_detected output
    end else begin
        current_state <= next_state;  // Update the current state
        if (current_state == S4) begin  // If the current state is S4
            sequence_detected <= 1'b1;  // Assert the sequence_detected output
        end else begin
            sequence_detected <= 1'b0;  // Otherwise, deassert the sequence_detected output
        end
    end
end

endmodule