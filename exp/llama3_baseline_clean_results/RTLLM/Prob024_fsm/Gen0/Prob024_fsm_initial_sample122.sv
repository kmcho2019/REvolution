module fsm(
    input  logic IN,  // Input signal to the FSM
    input  logic CLK, // Clock signal used for synchronous operation
    input  logic RST, // Reset signal to initialize the FSM
    output logic MATCH // Output signal indicating a match condition based on the FSM state
);

// Define the states of the FSM
enum logic [2:0] {
    S0, // Initial state, waiting for the first '1'
    S1, // Received '1', waiting for the first '0'
    S2, // Received '10', waiting for the second '0'
    S3, // Received '100', waiting for '1'
    S4  // Received '1001', waiting for the final '1'
} state, next_state;

// Output logic for MATCH
always_comb begin
    case (state)
        S4: MATCH = IN; // MATCH is 1 only when in S4 and input is '1'
        default: MATCH = 1'b0;
    endcase
end

// State transition logic
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin // Reset condition
        state <= S0; // Return to initial state
    end else begin
        case (state)
            S0: begin
                if (IN) state <= S1; // Move to S1 if input is '1'
                else state <= S0; // Stay in S0 if input is '0'
            end
            S1: begin
                if (!IN) state <= S2; // Move to S2 if input is '0'
                else state <= S1; // Stay in S1 if input is '1'
            end
            S2: begin
                if (!IN) state <= S2; // Stay in S2 if input is '0'
                else state <= S1; // Go back to S1 if input is '1'
            end
            S3: begin
                if (IN) state <= S4; // Move to S4 if input is '1'
                else state <= S0; // Go back to S0 if input is '0'
            end
            S4: begin
                if (IN) state <= S4; // Stay in S4 if input is '1'
                else state <= S0; // Go back to S0 if input is '0'
            end
            default: state <= S0; // Default condition, return to S0
        endcase
    end
end

endmodule