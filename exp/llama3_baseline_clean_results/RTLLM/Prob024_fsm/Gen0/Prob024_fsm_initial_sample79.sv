module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define the states
parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;

reg [2:0] current_state;

always @ (posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
        MATCH <= 0;
    end else begin
        case (current_state)
            S0: begin
                if (IN)
                    current_state <= S1;
                else
                    current_state <= S0;
            end
            S1: begin
                if (~IN)
                    current_state <= S2;
                else
                    current_state <= S1;
            end
            S2: begin
                if (~IN)
                    current_state <= S3;
                else
                    current_state <= S1;
            end
            S3: begin
                if (IN)
                    current_state <= S4;
                else
                    current_state <= S0;
            end
            S4: begin
                if (IN) begin
                    current_state <= S5;
                    MATCH <= 1;
                end else
                    current_state <= S0;
            end
            S5: begin
                current_state <= S0;
                MATCH <= 0;
            end
        endcase
    end
end

endmodule