module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // Using 3 bits to represent 8 states (including idle/reset state)
localparam S0 = 3'b000, // Idle or reset state
             S1 = 3'b001, // First '1' detected
             S2 = 3'b010, // First '0' after '1' detected
             S3 = 3'b011, // Second '0' detected
             S4 = 3'b100, // First '1' after two '0's detected
             S5 = 3'b101; // Second '1' detected, sequence matched

always @(posedge CLK or posedge RST) begin
    if (RST) begin // Reset condition
        state <= S0;
        MATCH <= 0;
    end else begin
        case (state)
            S0: begin // Initial state
                if (IN) begin
                    state <= S1; // Move to S1 if input is '1'
                    MATCH <= 0;
                end else begin
                    state <= S0; // Stay in S0 if input is '0'
                    MATCH <= 0;
                end
            end
            S1: begin // First '1' detected
                if (!IN) begin // Input is '0'
                    state <= S2;
                    MATCH <= 0;
                end else begin
                    state <= S1; // Still '1', stay in S1
                    MATCH <= 0;
                end
            end
            S2: begin // First '0' after '1' detected
                if (!IN) begin // Input is still '0'
                    state <= S3;
                    MATCH <= 0;
                end else begin
                    state <= S1; // Input is '1', go back to S1
                    MATCH <= 0;
                end
            end
            S3: begin // Second '0' detected
                if (IN) begin // Input is '1'
                    state <= S4;
                    MATCH <= 0;
                end else begin
                    state <= S3; // Still '0', stay in S3
                    MATCH <= 0;
                end
            end
            S4: begin // First '1' after two '0's detected
                if (IN) begin // Input is '1' again
                    state <= S5;
                    MATCH <= 1; // Sequence matched, set output to 1
                end else begin
                    state <= S2; // Input is '0', go back to S2
                    MATCH <= 0;
                end
            end
            S5: begin // Second '1' detected, sequence matched
                if (IN) begin // If input remains '1', stay in S5 but reset MATCH
                    state <= S5;
                    MATCH <= 0;
                end else begin
                    state <= S2; // If input is '0', go back to S2
                    MATCH <= 0;
                end
            end
            default: begin
                state <= S0; // Any other state, reset to S0
                MATCH <= 0;
            end
        endcase
    end
end

endmodule