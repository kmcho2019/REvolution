module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // States: S0 (0), S1 (1), S2 (2), S3 (3), S4 (4), S5 (5)

always @ (posedge CLK or posedge RST) begin
    if (RST) begin // Reset
        state <= 0; // Initialize to S0
        MATCH <= 0;
    end else begin
        case (state)
            0: begin // S0
                if (IN) begin
                    state <= 1; // Transition to S1
                end else begin
                    state <= 0; // Stay in S0
                end
                MATCH <= 0;
            end
            1: begin // S1
                if (!IN) begin
                    state <= 2; // Transition to S2
                end else begin
                    state <= 1; // Stay in S1
                end
                MATCH <= 0;
            end
            2: begin // S2
                if (!IN) begin
                    state <= 3; // Transition to S3
                end else begin
                    state <= 1; // Go back to S1
                end
                MATCH <= 0;
            end
            3: begin // S3
                if (IN) begin
                    state <= 4; // Transition to S4
                end else begin
                    state <= 1; // Go back to S1
                end
                MATCH <= 0;
            end
            4: begin // S4
                if (IN) begin
                    state <= 5; // Transition to S5
                end else begin
                    state <= 1; // Go back to S1
                end
                MATCH <= 0;
            end
            5: begin // S5
                if (IN) begin
                    MATCH <= 1; // Set MATCH to 1
                    state <= 5; // Stay in S5
                end else begin
                    state <= 1; // Go back to S1
                    MATCH <= 0;
                end
            end
            default: begin
                state <= 0; // Default to S0
                MATCH <= 0;
            end
        endcase
    end
end

endmodule