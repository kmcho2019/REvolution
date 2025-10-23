module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // 3 bits to represent 5 states (S0 to S4, considering encoding for states)

// Define states
parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101;

always @ (posedge CLK or posedge RST) begin
    if (RST) begin // Reset condition
        state <= S0;
        MATCH <= 0;
    end else begin
        case (state)
            S0: begin
                if (IN == 1) begin
                    state <= S1;
                end else begin
                    state <= S0;
                end
                MATCH <= 0;
            end
            S1: begin
                if (IN == 0) begin
                    state <= S2;
                end else begin
                    state <= S0; // Reset on unexpected input
                end
                MATCH <= 0;
            end
            S2: begin
                if (IN == 0) begin
                    state <= S3;
                end else begin
                    state <= S0; // Reset on unexpected input
                end
                MATCH <= 0;
            end
            S3: begin
                if (IN == 1) begin
                    state <= S4;
                end else begin
                    state <= S0; // Reset on unexpected input
                end
                MATCH <= 0;
            end
            S4: begin
                if (IN == 1) begin
                    state <= S0; // After detecting sequence, return to S0 for continuous detection
                    MATCH <= 1;
                end else begin
                    state <= S0; // Reset on unexpected input
                end
                if (IN!= 1) MATCH <= 0;
            end
            default: begin
                state <= S0;
                MATCH <= 0;
            end
        endcase
    end
end

endmodule