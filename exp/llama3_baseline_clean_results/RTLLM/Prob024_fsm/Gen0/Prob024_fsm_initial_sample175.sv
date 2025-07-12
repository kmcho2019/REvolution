module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output MATCH
);

reg [2:0] state; // 3 bits to represent 5 states (IDLE, S1, S2, S3, S4, S5) with two bits unused
reg match_reg;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 3'b000; // Reset state to IDLE
        match_reg <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // IDLE state
                if (IN) begin
                    state <= 3'b001; // Move to S1 if IN is 1
                end else begin
                    state <= 3'b000; // Stay in IDLE if IN is 0
                end
                match_reg <= 1'b0;
            end
            3'b001: begin // S1 state
                if (!IN) begin
                    state <= 3'b010; // Move to S2 if IN is 0
                end else begin
                    state <= 3'b001; // Stay in S1 if IN is 1
                end
                match_reg <= 1'b0;
            end
            3'b010: begin // S2 state
                if (!IN) begin
                    state <= 3'b011; // Move to S3 if IN is 0
                end else begin
                    state <= 3'b001; // Go back to S1 if IN is 1
                end
                match_reg <= 1'b0;
            end
            3'b011: begin // S3 state
                if (IN) begin
                    state <= 3'b100; // Move to S4 if IN is 1
                end else begin
                    state <= 3'b011; // Stay in S3 if IN is 0
                end
                match_reg <= 1'b0;
            end
            3'b100: begin // S4 state
                if (IN) begin
                    state <= 3'b100; // Stay in S4 if IN is 1, and set MATCH
                    match_reg <= 1'b1;
                end else begin
                    state <= 3'b000; // Go back to IDLE if IN is 0
                    match_reg <= 1'b0;
                end
            end
            default: begin
                state <= 3'b000; // Go back to IDLE for any other state
                match_reg <= 1'b0;
            end
        endcase
    end
end

assign MATCH = match_reg;

endmodule