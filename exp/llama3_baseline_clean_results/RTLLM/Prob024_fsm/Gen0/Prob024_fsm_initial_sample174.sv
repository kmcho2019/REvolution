module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // State variable to store the current state
localparam S0 = 3'b000; // Initial state
localparam S1 = 3'b001; // State after first 1
localparam S2 = 3'b010; // State after first 0
localparam S3 = 3'b011; // State after second 0
localparam S4 = 3'b100; // State after first 1 in second sequence
localparam S5 = 3'b101; // State after second 1 in second sequence

always @(posedge CLK or posedge RST) begin
    if (RST) begin // Reset condition
        state <= S0; // Reset state to S0
        MATCH <= 0; // Reset MATCH to 0
    end else begin
        case (state) // Current state
            S0: begin // Initial state
                if (IN) begin
                    state <= S1; // Move to S1 on input 1
                    MATCH <= 0; // MATCH is 0 in S1
                end else begin
                    state <= S0; // Stay in S0 on input 0
                    MATCH <= 0; // MATCH is 0 in S0
                end
            end
            S1: begin // State after first 1
                if (~IN) begin
                    state <= S2; // Move to S2 on input 0
                    MATCH <= 0; // MATCH is 0 in S2
                end else begin
                    state <= S1; // Stay in S1 on input 1
                    MATCH <= 0; // MATCH is 0 in S1
                end
            end
            S2: begin // State after first 0
                if (~IN) begin
                    state <= S3; // Move to S3 on input 0
                    MATCH <= 0; // MATCH is 0 in S3
                end else begin
                    state <= S1; // Move back to S1 on input 1
                    MATCH <= 0; // MATCH is 0 in S1
                end
            end
            S3: begin // State after second 0
                if (IN) begin
                    state <= S4; // Move to S4 on input 1
                    MATCH <= 0; // MATCH is 0 in S4
                end else begin
                    state <= S2; // Move back to S2 on input 0
                    MATCH <= 0; // MATCH is 0 in S2
                end
            end
            S4: begin // State after first 1 in second sequence
                if (IN) begin
                    state <= S5; // Move to S5 on input 1
                    MATCH <= 1; // MATCH is 1 in S5
                end else begin
                    state <= S0; // Move back to S0 on input 0
                    MATCH <= 0; // MATCH is 0 in S0
                end
            end
            S5: begin // State after second 1 in second sequence
                if (IN) begin
                    state <= S5; // Stay in S5 on input 1
                    MATCH <= 1; // MATCH is 1 in S5
                end else begin
                    state <= S0; // Move back to S0 on input 0
                    MATCH <= 0; // MATCH is 0 in S0
                end
            end
        endcase
    end
end

endmodule