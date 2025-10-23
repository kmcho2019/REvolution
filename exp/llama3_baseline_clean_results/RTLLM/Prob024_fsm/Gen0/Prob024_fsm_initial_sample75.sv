module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // 3 bits to represent 6 states (S0 to S5)

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 0; // Reset state to S0
        MATCH <= 0;
    end else begin
        case (state)
            0: begin // S0
                if (IN) begin
                    state <= 1; // Move to S1 if IN is 1
                end else begin
                    state <= 0; // Stay in S0 if IN is 0
                end
                MATCH <= 0;
            end
            1: begin // S1
                if (IN) begin
                    state <= 1; // Stay in S1 if IN is 1 (invalid sequence)
                end else begin
                    state <= 2; // Move to S2 if IN is 0
                end
                MATCH <= 0;
            end
            2: begin // S2
                if (IN) begin
                    state <= 2; // Stay in S2 if IN is 1 (invalid sequence)
                end else begin
                    state <= 3; // Move to S3 if IN is 0
                end
                MATCH <= 0;
            end
            3: begin // S3
                if (IN) begin
                    state <= 4; // Move to S4 if IN is 1
                end else begin
                    state <= 0; // Reset to S0 if IN is 0 (invalid sequence)
                end
                MATCH <= 0;
            end
            4: begin // S4
                if (IN) begin
                    state <= 5; // Move to S5 if IN is 1
                    MATCH <= 1; // Set MATCH to 1
                end else begin
                    state <= 0; // Reset to S0 if IN is 0 (invalid sequence)
                end
            end
            5: begin // S5
                if (IN) begin
                    MATCH <= 1; // Keep MATCH to 1 if IN is 1
                end else begin
                    MATCH <= 0; // Reset MATCH to 0 if IN is 0
                end
                state <= 0; // Reset to S0
            end
        endcase
    end
end

endmodule