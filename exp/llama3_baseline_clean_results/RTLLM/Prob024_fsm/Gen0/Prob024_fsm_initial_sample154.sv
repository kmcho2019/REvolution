module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

reg [2:0] state; // Using 3 bits to represent 5 states (S0 to S4)
parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 1'b0;
    end else begin
        case(state)
            S0: if (IN) state <= S1; // Wait for first '1'
            S1: if (!IN) state <= S2; else state <= S1; // Wait for '0' after first '1'
            S2: if (!IN) state <= S3; else state <= S1; // Wait for second '0'
            S3: if (IN) state <= S4; else state <= S1; // Wait for '1' after '00'
            S4: if (IN) state <= S0; // Final '1' detected, reset to S0 to check for new sequence
                 else state <= S1; // Incorrect sequence, restart
            default: state <= S0; // Invalid state, reset to S0
        endcase
        
        if (state == S4 && IN) begin
            MATCH <= 1'b1; // Set MATCH to '1' when sequence '10011' is detected
        end else begin
            MATCH <= 1'b0; // Otherwise, MATCH remains '0'
        end
    end
end

endmodule