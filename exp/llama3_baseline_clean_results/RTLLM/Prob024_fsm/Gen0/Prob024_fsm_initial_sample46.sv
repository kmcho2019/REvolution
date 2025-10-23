module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // State variable to keep track of current state
parameter S0 = 3'b000; // Initial state
parameter S1 = 3'b001; // State after first '1'
parameter S2 = 3'b010; // State after first '0'
parameter S3 = 3'b011; // State after second '0'
parameter S4 = 3'b100; // State after third '1'
parameter S5 = 3'b101; // Final state after fourth '1'

always @(posedge CLK or posedge RST) begin
    if (RST) begin // Reset condition
        state <= S0;
        MATCH <= 0;
    end else begin
        case (state)
            S0: begin
                if (IN == 1'b1) begin
                    state <= S1;
                    MATCH <= 0;
                end else begin
                    state <= S0;
                    MATCH <= 0;
                end
            end
            S1: begin
                if (IN == 1'b0) begin
                    state <= S2;
                    MATCH <= 0;
                end else begin
                    state <= S1;
                    MATCH <= 0;
                end
            end
            S2: begin
                if (IN == 1'b0) begin
                    state <= S3;
                    MATCH <= 0;
                end else if (IN == 1'b1) begin
                    state <= S1;
                    MATCH <= 0;
                end
            end
            S3: begin
                if (IN == 1'b1) begin
                    state <= S4;
                    MATCH <= 0;
                end else if (IN == 1'b0) begin
                    state <= S2;
                    MATCH <= 0;
                end
            end
            S4: begin
                if (IN == 1'b1) begin
                    state <= S5;
                    MATCH <= 1;
                end else begin
                    state <= S0;
                    MATCH <= 0;
                end
            end
            S5: begin
                if (IN == 1'b1) begin
                    state <= S5;
                    MATCH <= 1;
                end else begin
                    state <= S0;
                    MATCH <= 0;
                end
            end
            default: begin
                state <= S0;
                MATCH <= 0;
            end
        endcase
    end
end

endmodule