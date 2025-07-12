module fsm(
    input IN, // Input signal to the FSM
    input CLK, // Clock signal used for synchronous operation
    input RST, // Reset signal to initialize the FSM
    output reg MATCH // Output signal indicating a match condition based on the FSM state
);

reg [2:0] state; // Current state of the FSM

// Define the states
parameter S0 = 3'b000, // Initial state
           S1 = 3'b001, // Prefix "1"
           S2 = 3'b010, // Prefix "10"
           S3 = 3'b011, // Prefix "100"
           S4 = 3'b100, // Prefix "1001"
           S5 = 3'b101; // Full sequence "10011"

always @(posedge CLK or posedge RST) begin
    if (RST) begin // Reset condition
        state <= S0; // Reset to initial state
        MATCH <= 0; // Reset MATCH to 0
    end else begin
        case (state)
            S0: begin
                if (IN) begin
                    state <= S1; // Transition to S1 if input is 1
                    MATCH <= 0; // MATCH remains 0
                end else begin
                    state <= S0; // Stay in S0 if input is 0
                    MATCH <= 0; // MATCH remains 0
                end
            end
            S1: begin
                if (~IN) begin
                    state <= S2; // Transition to S2 if input is 0
                    MATCH <= 0; // MATCH remains 0
                end else begin
                    state <= S1; // Stay in S1 if input is 1
                    MATCH <= 0; // MATCH remains 0
                end
            end
            S2: begin
                if (~IN) begin
                    state <= S3; // Transition to S3 if input is 0
                    MATCH <= 0; // MATCH remains 0
                end else begin
                    state <= S1; // Reset to S1 if input is 1
                    MATCH <= 0; // MATCH remains 0
                end
            end
            S3: begin
                if (IN) begin
                    state <= S4; // Transition to S4 if input is 1
                    MATCH <= 0; // MATCH remains 0
                end else begin
                    state <= S1; // Reset to S1 if input is 0
                    MATCH <= 0; // MATCH remains 0
                end
            end
            S4: begin
                if (IN) begin
                    state <= S5; // Transition to S5 if input is 1
                    MATCH <= 1; // Set MATCH to 1
                end else begin
                    state <= S1; // Reset to S1 if input is 0
                    MATCH <= 0; // MATCH remains 0
                end
            end
            S5: begin
                if (~IN) begin
                    state <= S2; // Transition to S2 if input is 0
                    MATCH <= 0; // MATCH becomes 0 after the sequence
                end else begin
                    state <= S1; // Reset to S1 if input is 1
                    MATCH <= 0; // MATCH remains 0
                end
            end
            default: begin
                state <= S0; // Default to initial state
                MATCH <= 0; // Default MATCH to 0
            end
        endcase
    end
end

endmodule