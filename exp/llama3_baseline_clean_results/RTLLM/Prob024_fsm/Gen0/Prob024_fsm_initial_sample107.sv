module fsm(
    input IN,      // Input signal to the FSM
    input CLK,     // Clock signal for synchronous operation
    input RST,     // Reset signal to initialize the FSM
    output reg MATCH  // Output signal indicating a match condition
);

// Define the states of the FSM
typedef enum logic [2:0] {
    S0,  // Initial state
    S1,  // State after detecting the first '1'
    S2,  // State after detecting the first '0' after '1'
    S3,  // State after detecting the second '0'
    S4,  // State after detecting '1' after '00'
    S5   // Final state, sequence detected
} state_t;

// Initialize the current state
state_t current_state;

// Always block for sequential logic (clocked processes)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        // Reset the FSM to the initial state
        current_state <= S0;
        MATCH <= 0;
    end else begin
        case (current_state)
            S0: begin
                if (IN) begin
                    // Transition to S1 if input is '1'
                    current_state <= S1;
                end else begin
                    // Stay in S0 if input is '0'
                    current_state <= S0;
                end
                MATCH <= 0;  // No match in S0
            end
            S1: begin
                if (!IN) begin
                    // Transition to S2 if input is '0' after '1'
                    current_state <= S2;
                end else begin
                    // Reset to S1 if input remains '1'
                    current_state <= S1;
                end
                MATCH <= 0;  // No match in S1
            end
            S2: begin
                if (!IN) begin
                    // Transition to S3 if input is '0' after '0'
                    current_state <= S3;
                end else begin
                    // Reset to S1 if input is '1' instead of expected '0'
                    current_state <= S1;
                end
                MATCH <= 0;  // No match in S2
            end
            S3: begin
                if (IN) begin
                    // Transition to S4 if input is '1' after '00'
                    current_state <= S4;
                end else begin
                    // Stay in S3 if input is '0'
                    current_state <= S3;
                end
                MATCH <= 0;  // No match in S3
            end
            S4: begin
                if (IN) begin
                    // Transition to S5 if input is '1' after '1'
                    current_state <= S5;
                end else begin
                    // Reset to S0 if input is '0' instead of expected '1'
                    current_state <= S0;
                end
                MATCH <= 0;  // No match in S4
            end
            S5: begin
                // Set MATCH to 1 when in S5
                MATCH <= 1;
                if (IN) begin
                    // Stay in S5 if input continues with '1'
                    current_state <= S5;
                end else begin
                    // Transition back to S0 if input is '0'
                    current_state <= S0;
                end
            end
            default: begin
                current_state <= S0;  // Default to S0 for any invalid state
                MATCH <= 0;
            end
        endcase
    end
end

endmodule