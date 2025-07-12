module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// Define the states of the FSM
typedef enum logic [2:0] {
    IDLE = 3'b001,
    S1 = 3'b010,
    S2 = 3'b011,
    S3 = 3'b100,
    S4 = 3'b101
} state_t;

// Declare the current and next states
state_t current_state, next_state;

// Assign the output sequence_detected
assign sequence_detected = (current_state == S4)? 1'b1 : 1'b0;

// Sequential logic
always_ff @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        // Reset the state machine to IDLE state
        current_state <= IDLE;
    end else begin
        // Update the current state
        current_state <= next_state;
    end
end

// Combinational logic
always_comb begin
    case (current_state)
        IDLE: begin
            if (data_in == 1'b1) begin
                // Transition to S1 when the first '1' is detected
                next_state = S1;
            end else begin
                // Stay in IDLE state if the input is not '1'
                next_state = IDLE;
            end
        end
        S1: begin
            if (data_in == 1'b0) begin
                // Transition to S2 when the next '0' is detected
                next_state = S2;
            end else begin
                // Reset to IDLE state if the input is not '0'
                next_state = IDLE;
            end
        end
        S2: begin
            if (data_in == 1'b0) begin
                // Transition to S3 when the next '0' is detected
                next_state = S3;
            end else begin
                // Reset to IDLE state if the input is not '0'
                next_state = IDLE;
            end
        end
        S3: begin
            if (data_in == 1'b1) begin
                // Transition to S4 when the last '1' is detected
                next_state = S4;
            end else begin
                // Reset to IDLE state if the input is not '1'
                next_state = IDLE;
            end
        end
        S4: begin
            // Reset to IDLE state after detecting the complete sequence
            next_state = IDLE;
        end
        default: begin
            // Default to IDLE state
            next_state = IDLE;
        end
    endcase
end

endmodule