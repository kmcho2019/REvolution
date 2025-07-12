module fsm(
    input  logic IN,  // Input signal to the FSM
    input  logic CLK, // Clock signal used for synchronous operation
    input  logic RST, // Reset signal to initialize the FSM
    output logic MATCH // Output signal indicating a match condition based on the FSM state
);

// Define the states of the FSM
enum logic [2:0] {
    S0, // Initial state
    S1, // State after first '1'
    S2, // State after '10'
    S3, // State after '100'
    S4  // State after '1001'
} state, next_state;

// Always block for sequential logic (state register)
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0; // Reset to initial state on reset
        MATCH <= 0;
    end else begin
        state <= next_state; // Update state on clock edge
    end
end

// Combinational logic for next state and output
always_comb begin
    next_state = state; // Default: stay in current state
    MATCH = 0; // Default: no match

    case (state)
        S0: begin
            if (IN) begin
                next_state = S1;
            end
        end
        S1: begin
            if (!IN) begin
                next_state = S2;
            end else begin
                next_state = S1; // Stay in S1 if '1' is seen again
            end
        end
        S2: begin
            if (!IN) begin
                next_state = S3;
            end else begin
                next_state = S1; // Go back to S1 if '1' is seen
            end
        end
        S3: begin
            if (IN) begin
                next_state = S4;
            end else begin
                next_state = S1; // Go back to S1 if '0' is seen
            end
        end
        S4: begin
            if (IN) begin
                MATCH = 1; // Assert match signal
                next_state = S4; // Stay in S4 if '1' is seen again
            end else begin
                next_state = S1; // Go back to S1 if '0' is seen
            end
        end
    endcase
end

endmodule