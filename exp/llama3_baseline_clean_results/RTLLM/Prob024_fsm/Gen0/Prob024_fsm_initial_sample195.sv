module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101;

reg [2:0] current_state, next_state;

always @ (posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
        MATCH <= 0;
    end else begin
        current_state <= next_state;
        case (current_state)
            S0: begin
                if (IN) next_state <= S1;
                else next_state <= S0;
                MATCH <= 0;
            end
            S1: begin
                if (!IN) next_state <= S2;
                else next_state <= S1;
                MATCH <= 0;
            end
            S2: begin
                if (!IN) next_state <= S3;
                else next_state <= S0;
                MATCH <= 0;
            end
            S3: begin
                if (IN) next_state <= S4;
                else next_state <= S0;
                MATCH <= 0;
            end
            S4: begin
                if (IN) next_state <= S5;
                else next_state <= S0;
                MATCH <= 0;
            end
            S5: begin
                MATCH <= 1;
                if (IN) next_state <= S1;
                else next_state <= S0;
            end
            default: next_state <= S0;
        endcase
    end
end

endmodule