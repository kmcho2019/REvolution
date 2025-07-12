module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} current_state, next_state;

// Assign the output sequence_detected to 0 by default
assign sequence_detected = (current_state == S4) ? 1'b1 : 1'b0;

// Describe the sequential logic of the FSM
always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        // Reset the FSM to the IDLE state when reset is high
        current_state <= IDLE;
    end else begin
        // Update the current state to the next state on each clock cycle
        current_state <= next_state;
    end
end

// Describe the combinational logic of the FSM
always_comb begin
    case (current_state)
        IDLE: begin
            // Transition to S1 when the first bit of the sequence is detected
            if (data_in == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            // Transition to S2 when the second bit of the sequence is detected
            if (data_in == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = IDLE;
            end
        end
        S2: begin
            // Transition to S3 when the third bit of the sequence is detected
            if (data_in == 1'b0) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
            end
        end
        S3: begin
            // Transition to S4 when the fourth bit of the sequence is detected
            if (data_in == 1'b1) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        end
        S4: begin
            // Reset the FSM to the IDLE state after detecting the sequence
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule