module fsm(
    input IN,  // Input signal to the FSM
    input CLK,  // Clock signal used for synchronous operation
    input RST,  // Reset signal to initialize the FSM
    output reg MATCH  // Output signal indicating a match condition based on the FSM state
);

reg [2:0] state;  // State register to keep track of the current state
parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;  // Reset state to S0 on reset
        MATCH <= 1'b0;  // Reset MATCH to 0 on reset
    end else begin
        case (state)
            S0: begin
                if (IN == 1'b1) begin
                    state <= S1;  // Transition to S1 on '1' input
                end else begin
                    state <= S0;  // Stay in S0 for other inputs
                end
            end
            S1: begin
                if (IN == 1'b0) begin
                    state <= S2;  // Transition to S2 on '0' input
                end else begin
                    state <= S1;  // Stay in S1 for '1' input
                end
            end
            S2: begin
                if (IN == 1'b0) begin
                    state <= S3;  // Transition to S3 on '0' input
                end else begin
                    state <= S1;  // Back to S1 for '1' input
                end
            end
            S3: begin
                if (IN == 1'b1) begin
                    state <= S4;  // Transition to S4 on '1' input
                end else begin
                    state <= S0;  // Back to S0 for '0' input
                end
            end
            S4: begin
                if (IN == 1'b1) begin
                    state <= S5;  // Transition to S5 on '1' input
                    MATCH <= 1'b1;  // Set MATCH to 1 in S5 for '1' input
                end else begin
                    state <= S0;  // Back to S0 for '0' input
                    MATCH <= 1'b0;  // Reset MATCH for '0' input
                end
            end
            S5: begin
                MATCH <= 1'b0;  // Reset MATCH after setting it in the previous cycle
                if (IN == 1'b1) begin
                    state <= S1;  // Transition back to S1 for continuous '1' input
                end else if (IN == 1'b0) begin
                    state <= S0;  // Transition back to S0 for '0' input
                end
            end
            default: begin
                state <= S0;  // Default state transition
                MATCH <= 1'b0;  // Default MATCH value
            end
        endcase
    end
end

endmodule