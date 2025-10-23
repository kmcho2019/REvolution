module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // 3 bits can represent 8 states, but we only need 6

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 0; // Reset state to S0
        MATCH <= 0;
    end else begin
        case (state)
            0: begin // S0
                if (IN) begin
                    state <= 1; // Move to S1
                    MATCH <= 0;
                end else begin
                    state <= 0; // Stay in S0
                    MATCH <= 0;
                end
            end
            1: begin // S1
                if (!IN) begin
                    state <= 2; // Move to S2
                    MATCH <= 0;
                end else begin
                    state <= 0; // Reset to S0
                    MATCH <= 0;
                end
            end
            2: begin // S2
                if (!IN) begin
                    state <= 3; // Move to S3
                    MATCH <= 0;
                end else begin
                    state <= 0; // Reset to S0
                    MATCH <= 0;
                end
            end
            3: begin // S3
                if (IN) begin
                    state <= 4; // Move to S4
                    MATCH <= 0;
                end else begin
                    state <= 0; // Reset to S0
                    MATCH <= 0;
                end
            end
            4: begin // S4
                if (IN) begin
                    state <= 5; // Move to S5
                    MATCH <= 1; // Set MATCH to 1
                end else begin
                    state <= 0; // Reset to S0
                    MATCH <= 0;
                end
            end
            5: begin // S5
                state <= 0; // Reset to S0 after setting MATCH
                MATCH <= 0; // Reset MATCH after one clock cycle
            end
            default: begin
                state <= 0; // Reset to S0 for any other state
                MATCH <= 0;
            end
        endcase
    end
end

endmodule