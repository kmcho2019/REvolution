module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // States: 0 - Idle, 1 - S1, 2 - S2, 3 - S3, 4 - S4, 5 - S5

always @ (posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 0; // Reset to Idle state
        MATCH <= 0;
    end else begin
        case (state)
            0: begin // Idle state
                if (IN) begin
                    state <= 1; // Transition to S1
                    MATCH <= 0;
                end else begin
                    state <= 0; // Stay in Idle
                    MATCH <= 0;
                end
            end
            1: begin // S1 state
                if (!IN) begin
                    state <= 2; // Transition to S2
                    MATCH <= 0;
                end else begin
                    state <= 1; // Stay in S1
                    MATCH <= 0;
                end
            end
            2: begin // S2 state
                if (!IN) begin
                    state <= 3; // Transition to S3
                    MATCH <= 0;
                end else begin
                    state <= 1; // Reset to S1
                    MATCH <= 0;
                end
            end
            3: begin // S3 state
                if (IN) begin
                    state <= 4; // Transition to S4
                    MATCH <= 0;
                end else begin
                    state <= 2; // Reset to S2
                    MATCH <= 0;
                end
            end
            4: begin // S4 state
                if (IN) begin
                    state <= 5; // Transition to S5
                    MATCH <= 1; // Set MATCH to 1
                end else begin
                    state <= 1; // Reset to S1
                    MATCH <= 0;
                end
            end
            5: begin // S5 state
                if (IN) begin
                    state <= 1; // Reset to S1
                    MATCH <= 0;
                end else begin
                    state <= 2; // Reset to S2
                    MATCH <= 0;
                end
            end
        endcase
    end
end

endmodule