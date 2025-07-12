module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // 0: IDLE, 1: S1, 2: S2, 3: S3, 4: S4, 5: MATCH_STATE

always @ (posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 0; // IDLE state
        MATCH <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (IN) begin
                    state <= 1; // S1 state
                    MATCH <= 0;
                end else begin
                    state <= 0; // Stay in IDLE state
                    MATCH <= 0;
                end
            end
            1: begin // S1 state
                if (~IN) begin
                    state <= 2; // S2 state
                    MATCH <= 0;
                end else begin
                    state <= 1; // Stay in S1 state
                    MATCH <= 0;
                end
            end
            2: begin // S2 state
                if (~IN) begin
                    state <= 3; // S3 state
                    MATCH <= 0;
                end else begin
                    state <= 0; // Back to IDLE state
                    MATCH <= 0;
                end
            end
            3: begin // S3 state
                if (IN) begin
                    state <= 4; // S4 state
                    MATCH <= 0;
                end else begin
                    state <= 0; // Back to IDLE state
                    MATCH <= 0;
                end
            end
            4: begin // S4 state
                if (IN) begin
                    state <= 5; // MATCH_STATE
                    MATCH <= 1;
                end else begin
                    state <= 0; // Back to IDLE state
                    MATCH <= 0;
                end
            end
            5: begin // MATCH_STATE
                MATCH <= 0; // Reset MATCH after one clock cycle
                if (IN) begin
                    state <= 1; // S1 state
                end else begin
                    state <= 0; // IDLE state
                end
            end
        endcase
    end
end

endmodule