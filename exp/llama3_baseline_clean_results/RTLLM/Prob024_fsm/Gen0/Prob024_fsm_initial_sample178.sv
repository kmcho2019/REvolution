module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

reg [2:0] state; // State register to hold the current state
parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101;

always @(posedge CLK or posedge RST) begin
    if(RST) begin // Reset condition
        state <= S0; // Initialize state to S0
        MATCH <= 0; // Reset MATCH to 0
    end else begin
        case(state)
            S0: begin
                if(IN) begin
                    state <= S1; // Transition to S1 on input '1'
                    MATCH <= 0; // MATCH remains 0
                end else begin
                    state <= S0; // Stay in S0 if input is '0'
                    MATCH <= 0; // MATCH remains 0
                end
            end
            S1: begin
                if(!IN) begin
                    state <= S2; // Transition to S2 on input '0'
                    MATCH <= 0; // MATCH remains 0
                end else begin
                    state <= S1; // Stay in S1 if input is '1' again
                    MATCH <= 0; // MATCH remains 0
                end
            end
            S2: begin
                if(!IN) begin
                    state <= S3; // Transition to S3 on input '0'
                    MATCH <= 0; // MATCH remains 0
                end else begin
                    state <= S1; // Transition back to S1 if input is '1'
                    MATCH <= 0; // MATCH remains 0
                end
            end
            S3: begin
                if(IN) begin
                    state <= S4; // Transition to S4 on input '1'
                    MATCH <= 0; // MATCH remains 0
                end else begin
                    state <= S2; // Transition back to S2 if input is '0'
                    MATCH <= 0; // MATCH remains 0
                end
            end
            S4: begin
                if(IN) begin
                    state <= S5; // Transition to S5 on input '1'
                    MATCH <= 1; // Set MATCH to 1
                end else begin
                    state <= S3; // Transition back to S3 if input is '0'
                    MATCH <= 0; // MATCH remains 0
                end
            end
            S5: begin
                if(IN) begin
                    state <= S5; // Stay in S5 if input continues as '1'
                    MATCH <= 1; // MATCH remains 1
                end else begin
                    state <= S2; // Transition back to S2 if input is '0'
                    MATCH <= 0; // MATCH remains 0
                end
            end
            default: begin
                state <= S0; // Default state transition to S0
                MATCH <= 0; // MATCH remains 0
            end
        endcase
    end
end

endmodule