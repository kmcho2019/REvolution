module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define the states of the FSM
typedef enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state_t;

// Initialize the current state and next state
state_t current_state, next_state;

// Assign the initial value of sequence_detected to 0
initial sequence_detected = 0;

// Always block to handle reset
always @(posedge reset_n or posedge clk) begin
    if (!reset_n) begin
        // Reset to IDLE state when reset_n is low
        current_state <= IDLE;
        sequence_detected <= 0;
    end else if (clk) begin
        // Update the current state on each clock cycle
        current_state <= next_state;
        
        // Set sequence_detected high when the final state (S4) is reached
        if (next_state == S4) begin
            sequence_detected <= 1;
        end else begin
            sequence_detected <= 0;
        end
    end
end

// Combinational logic to determine the next state
always @(*) begin
    case (current_state)
        IDLE: begin
            if (data_in == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (data_in == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = IDLE;
            end
        end
        S2: begin
            if (data_in == 1'b0) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
            end
        end
        S3: begin
            if (data_in == 1'b1) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        end
        S4: begin
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule