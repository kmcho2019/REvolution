module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

parameter S0 = 5'b00000;
parameter S1 = 5'b00001;
parameter S2 = 5'b00010;
parameter S3 = 5'b00100;
parameter S4 = 5'b01000;
parameter S5 = 5'b10000;

reg [4:0] current_state;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
        MATCH <= 0;
    end else begin
        case (current_state)
            S0: begin
                if (IN) begin
                    current_state <= S1;
                    MATCH <= 0;
                end else begin
                    current_state <= S0;
                    MATCH <= 0;
                end
            end
            S1: begin
                if (!IN) begin
                    current_state <= S2;
                    MATCH <= 0;
                end else begin
                    current_state <= S1;
                    MATCH <= 0;
                end
            end
            S2: begin
                if (!IN) begin
                    current_state <= S3;
                    MATCH <= 0;
                end else begin
                    current_state <= S1;
                    MATCH <= 0;
                end
            end
            S3: begin
                if (IN) begin
                    current_state <= S4;
                    MATCH <= 0;
                end else begin
                    current_state <= S2;
                    MATCH <= 0;
                end
            end
            S4: begin
                if (IN) begin
                    current_state <= S5;
                    MATCH <= 1;
                end else begin
                    current_state <= S0;
                    MATCH <= 0;
                end
            end
            S5: begin
                if (IN) begin
                    current_state <= S1;
                    MATCH <= 0;
                end else begin
                    current_state <= S0;
                    MATCH <= 0;
                end
            end
            default: begin
                current_state <= S0;
                MATCH <= 0;
            end
        endcase
    end
end

endmodule