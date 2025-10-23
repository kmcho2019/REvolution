module fsm (
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 3'b000; // Reset to S0
        MATCH <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // S0
                if (IN) begin
                    state <= 3'b001; // Move to S1
                    MATCH <= 1'b0;
                end else begin
                    state <= 3'b000; // Stay in S0
                    MATCH <= 1'b0;
                end
            end
            3'b001: begin // S1
                if (!IN) begin
                    state <= 3'b010; // Move to S2
                    MATCH <= 1'b0;
                end else begin
                    state <= 3'b000; // Reset to S0
                    MATCH <= 1'b0;
                end
            end
            3'b010: begin // S2
                if (!IN) begin
                    state <= 3'b011; // Move to S3
                    MATCH <= 1'b0;
                end else begin
                    state <= 3'b000; // Reset to S0
                    MATCH <= 1'b0;
                end
            end
            3'b011: begin // S3
                if (IN) begin
                    state <= 3'b100; // Move to S4
                    MATCH <= 1'b0;
                end else begin
                    state <= 3'b000; // Reset to S0
                    MATCH <= 1'b0;
                end
            end
            3'b100: begin // S4
                if (IN) begin
                    state <= 3'b101; // Move to S5
                    MATCH <= 1'b1;
                end else begin
                    state <= 3'b000; // Reset to S0
                    MATCH <= 1'b0;
                end
            end
            3'b101: begin // S5
                if (IN) begin
                    state <= 3'b101; // Stay in S5
                    MATCH <= 1'b1;
                end else begin
                    state <= 3'b000; // Reset to S0
                    MATCH <= 1'b0;
                end
            end
            default: begin
                state <= 3'b000; // Reset to S0
                MATCH <= 1'b0;
            end
        endcase
    end
end

endmodule