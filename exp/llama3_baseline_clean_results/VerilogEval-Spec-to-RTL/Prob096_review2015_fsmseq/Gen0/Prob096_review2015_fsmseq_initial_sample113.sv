module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define the states
typedef enum {
    Idle,
    State1,
    State2,
    State3,
    Shift
} state_t;

// Initialize the current state
state_t current_state = Idle;

// Initialize the output
reg start_shifting_reg = 0;

always @(posedge clk) begin
    if (reset) begin
        // Reset the current state and output
        current_state <= Idle;
        start_shifting_reg <= 0;
    end else begin
        case (current_state)
            Idle: begin
                if (data) begin
                    // Transition to State1 if '1' is received
                    current_state <= State1;
                end else begin
                    // Stay in Idle if '0' is received
                    current_state <= Idle;
                end
            end
            State1: begin
                if (data) begin
                    // Transition to State2 if '1' is received
                    current_state <= State2;
                end else begin
                    // Go back to Idle if '0' is received
                    current_state <= Idle;
                end
            end
            State2: begin
                if (!data) begin
                    // Transition to State3 if '0' is received
                    current_state <= State3;
                end else begin
                    // Go back to State1 if '1' is received
                    current_state <= State1;
                end
            end
            State3: begin
                if (data) begin
                    // Transition to Shift if '1' is received
                    current_state <= Shift;
                    start_shifting_reg <= 1;
                end else begin
                    // Go back to Idle if '0' is received
                    current_state <= Idle;
                end
            end
            Shift: begin
                // Stay in Shift state and keep start_shifting high
                current_state <= Shift;
            end
        endcase
    end
end

// Assign the output
assign start_shifting = start_shifting_reg;

endmodule