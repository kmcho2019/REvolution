module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // States: S0 (3'b000), S1 (3'b001), S2 (3'b010), S3 (3'b011), S4 (3'b100), S5 (3'b101)

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 3'b000; // Reset to initial state S0
        MATCH <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // S0
                if (IN) begin
                    state <= 3'b001; // Transition to S1
                end else begin
                    state <= 3'b000; // Stay in S0
                end
                MATCH <= 1'b0;
            end
            3'b001: begin // S1
                if (!IN) begin
                    state <= 3'b010; // Transition to S2
                end else begin
                    state <= 3'b001; // Stay in S1
                end
                MATCH <= 1'b0;
            end
            3'b010: begin // S2
                if (!IN) begin
                    state <= 3'b011; // Transition to S3
                end else begin
                    state <= 3'b001; // Go back to S1
                end
                MATCH <= 1'b0;
            end
            3'b011: begin // S3
                if (IN) begin
                    state <= 3'b100; // Transition to S4
                end else begin
                    state <= 3'b010; // Go back to S2
                end
                MATCH <= 1'b0;
            end
            3'b100: begin // S4
                if (IN) begin
                    state <= 3'b101; // Transition to S5
                end else begin
                    state <= 3'b011; // Go back to S3
                end
                MATCH <= 1'b0;
            end
            3'b101: begin // S5
                if (IN) begin
                    MATCH <= 1'b1; // Set MATCH to 1
                    state <= 3'b101; // Stay in S5
                end else begin
                    state <= 3'b010; // Go back to S2
                    MATCH <= 1'b0;
                end
            end
            default: begin
                state <= 3'b000; // Default to S0
                MATCH <= 1'b0;
            end
        endcase
    end
end

endmodule