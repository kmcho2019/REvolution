module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

reg [2:0] state; // IDLE, S1, S2, S3, S4, MATCH
reg match_reg;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 0; // IDLE state
        match_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (IN) begin
                    state <= 1; // S1 state
                end else begin
                    state <= 0; // stay in IDLE state
                end
            end
            1: begin // S1 state
                if (!IN) begin
                    state <= 2; // S2 state
                end else begin
                    state <= 1; // stay in S1 state
                end
            end
            2: begin // S2 state
                if (!IN) begin
                    state <= 3; // S3 state
                end else begin
                    state <= 1; // go back to S1 state
                end
            end
            3: begin // S3 state
                if (IN) begin
                    state <= 4; // S4 state
                end else begin
                    state <= 1; // go back to S1 state
                end
            end
            4: begin // S4 state
                if (IN) begin
                    state <= 5; // MATCH state
                    match_reg <= 1;
                end else begin
                    state <= 1; // go back to S1 state
                end
            end
            5: begin // MATCH state
                match_reg <= 0;
                if (IN) begin
                    state <= 1; // go back to S1 state
                end else begin
                    state <= 0; // go back to IDLE state
                end
            end
        endcase
    end
end

assign MATCH = match_reg;

endmodule