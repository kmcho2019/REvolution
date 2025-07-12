module sequence_detector (
    input  logic clk, 
    input  logic reset_n, 
    input  logic data_in, 
    output logic sequence_detected
);

// Define states as parameters for better readability
parameter IDLE = 4'd0;
parameter S1    = 4'd1;
parameter S2    = 4'd2;
parameter S3    = 4'd3;
parameter S4    = 4'd4;

// Declare the current and next states
logic [3:0] current_state, next_state;

// Synchronous logic to describe the state machine
always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        // Reset the state machine to IDLE state when reset is asserted
        current_state <= IDLE;
    end else begin
        // Update the current state based on the next state
        current_state <= next_state;
    end
end

// Combinational logic to describe the next state and sequence detection
always_comb begin
    case (current_state)
        IDLE: begin
            // Transition to S1 if the input is 1, otherwise stay in IDLE
            if (data_in) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            // Transition to S2 if the input is 0, otherwise reset to IDLE
            if (!data_in) begin
                next_state = S2;
            end else begin
                next_state = IDLE;
            end
        end
        S2: begin
            // Transition to S3 if the input is 0, otherwise reset to IDLE
            if (!data_in) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
            end
        end
        S3: begin
            // Transition to S4 if the input is 1, otherwise reset to IDLE
            if (data_in) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        end
        S4: begin
            // Stay in S4 only for one clock cycle to generate a single pulse for sequence detection
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
    
    // Assert sequence_detected high only when in S4 state
    if (current_state == S4) begin
        sequence_detected = 1'b1;
    end else begin
        sequence_detected = 1'b0;
    end
end

endmodule